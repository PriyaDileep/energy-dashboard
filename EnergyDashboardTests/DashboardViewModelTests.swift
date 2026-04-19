//
//  DashboardViewModelTests.swift
//  EnergyDashboardTests
//
//  Created by Priyanka on 19/4/2026.
//

//
//  DashboardViewModelTests.swift
//  EnergyDashboardTests
//

import XCTest
@testable import EnergyDashboard

@MainActor
final class DashboardViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockService: MockDataService!
    private var sut: DashboardViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        sut = DashboardViewModel(dataService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func test_initialState_allStreamsAreIdle() {
        // Given a freshly initialised view model

        // Then all three state streams should be idle
        XCTAssertEqual(sut.fuelState.debugDescription, ViewState<[FuelTransaction]>.idle.debugDescription)
        XCTAssertEqual(sut.chargeState.debugDescription, ViewState<[ChargeSession]>.idle.debugDescription)
        XCTAssertEqual(sut.offersState.debugDescription, ViewState<[StoreOffer]>.idle.debugDescription)
    }

    // MARK: - Success path

    func test_load_whenAllServicesSucceed_transitionsAllStatesToLoaded() async {
        // Given stubbed data for all three streams
        mockService.stubbedTransactions = [.fixture()]
        mockService.stubbedSessions = [.fixture()]
        mockService.stubbedOffers = [.fixture()]

        // When load is invoked
        await sut.load()

        // Then all three streams should be in the loaded state
        guard case .success(let transactions) = sut.fuelState else {
            return XCTFail("Expected fuelState to be .loaded")
        }
        XCTAssertEqual(transactions.count, 1)

        guard case .success(let sessions) = sut.chargeState else {
            return XCTFail("Expected chargeState to be .loaded")
        }
        XCTAssertEqual(sessions.count, 1)

        guard case .success(let offers) = sut.offersState else {
            return XCTFail("Expected offersState to be .loaded")
        }
        XCTAssertEqual(offers.count, 1)
    }

    func test_load_callsAllThreeServiceMethodsExactlyOnce() async {
        // Given stubbed data
        mockService.stubbedTransactions = []
        mockService.stubbedSessions = []
        mockService.stubbedOffers = []

        // When load is invoked
        await sut.load()

        // Then each service method should have been called exactly once
        XCTAssertEqual(mockService.getFuelTransactionsCallCount, 1)
        XCTAssertEqual(mockService.getChargeSessionsCallCount, 1)
        XCTAssertEqual(mockService.getStoreOffersCallCount, 1)
    }

    // MARK: - Error path

    func test_load_whenServiceThrows_transitionsAllStatesToError() async {
        // Given a service that always throws
        mockService.shouldThrow = true

        // When load is invoked
        await sut.load()

        // Then all three streams should be in the error state
        if case .error = sut.fuelState {} else {
            XCTFail("Expected fuelState to be .error")
        }
        if case .error = sut.chargeState {} else {
            XCTFail("Expected chargeState to be .error")
        }
        if case .error = sut.offersState {} else {
            XCTFail("Expected offersState to be .error")
        }
    }

    // MARK: - Derived state

    func test_recentFuelTransactions_returnsOnlyTheFirstTwo() async {
        // Given four stubbed transactions (more than the preview count of 2)
        mockService.stubbedTransactions = [
            .fixture(id: UUID()),
            .fixture(id: UUID()),
            .fixture(id: UUID()),
            .fixture(id: UUID())
        ]

        // When load completes
        await sut.load()

        // Then the dashboard should expose only the first two
        XCTAssertEqual(sut.recentFuelTransactions.count, AppConstants.Behaviour.dashboardPreviewCount)
    }

    func test_activeSession_whenOneSessionIsActive_returnsThatSession() async {
        // Given a mix of active and completed sessions
        let activeId = UUID()
        mockService.stubbedSessions = [
            .fixture(isActive: false),
            .fixture(id: activeId, isActive: true),
            .fixture(isActive: false)
        ]

        // When load completes
        await sut.load()

        // Then activeSession returns the one that is active
        XCTAssertEqual(sut.activeSession?.id, activeId)
    }

    func test_activeSession_whenNoSessionIsActive_returnsNil() async {
        // Given only completed sessions
        mockService.stubbedSessions = [
            .fixture(isActive: false),
            .fixture(isActive: false)
        ]

        // When load completes
        await sut.load()

        // Then activeSession is nil
        XCTAssertNil(sut.activeSession)
    }

    func test_featuredOffer_returnsTheFirstOffer() async {
        // Given three offers
        let firstId = UUID()
        mockService.stubbedOffers = [
            .fixture(id: firstId),
            .fixture(),
            .fixture()
        ]

        // When load completes
        await sut.load()

        // Then featuredOffer is the first one
        XCTAssertEqual(sut.featuredOffer?.id, firstId)
    }

    // MARK: - Loading state

    func test_load_whenCalledMultipleTimes_reloadsCleanly() async {
        // Given data
        mockService.stubbedTransactions = [.fixture()]
        mockService.stubbedSessions = [.fixture()]
        mockService.stubbedOffers = [.fixture()]

        // When load is called twice
        await sut.load()
        await sut.load()

        // Then each service method should have been called twice
        XCTAssertEqual(mockService.getFuelTransactionsCallCount, 2)
        XCTAssertEqual(mockService.getChargeSessionsCallCount, 2)
        XCTAssertEqual(mockService.getStoreOffersCallCount, 2)
    }

    func test_refresh_delegatesToLoad() async {
        // Given stubbed data
        mockService.stubbedTransactions = [.fixture()]
        mockService.stubbedSessions = [.fixture()]
        mockService.stubbedOffers = [.fixture()]

        // When refresh is invoked
        await sut.refresh()

        // Then each service method should have been called once (same as load)
        XCTAssertEqual(mockService.getFuelTransactionsCallCount, 1)
        XCTAssertEqual(mockService.getChargeSessionsCallCount, 1)
        XCTAssertEqual(mockService.getStoreOffersCallCount, 1)
    }
}

// MARK: - ViewState debug helper

/// Gives `ViewState` a human-readable description in test failures.
/// Not used in production — compiled only for the test target.
extension ViewState {
    var debugDescription: String {
        switch self {
        case .idle: return "idle"
        case .loading: return "loading"
        case .success: return "loaded"
        case .error: return "error"
        }
    }
}
