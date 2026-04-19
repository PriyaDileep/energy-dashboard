//
//  FuelTransactionsViewModelTests.swift
//  EnergyDashboardTests
//
//  Created by Priyanka on 19/4/2026.
//

import XCTest
@testable import EnergyDashboard

@MainActor
final class FuelTransactionsViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockService: MockDataService!
    private var testSubject: FuelTransactionsViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        testSubject = FuelTransactionsViewModel(dataService: mockService)
    }

    override func tearDown() {
        testSubject = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func date(year: Int, month: Int = 1, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = TimeZone(identifier: "Australia/Brisbane")
        return Calendar(identifier: .gregorian).date(from: components)!
    }

    // MARK: - State transitions

    func test_initialState_isIdle() {
        if case .idle = testSubject.state {} else {
            XCTFail("Expected initial state to be .idle")
        }
    }

    func test_load_onSuccess_transitionsToLoaded() async {
        // Given a service that returns one transaction
        mockService.stubbedTransactions = [.fixture()]

        // When load is invoked
        await testSubject.load()

        // Then state is .loaded
        guard case .success(let transactions) = testSubject.state else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertEqual(transactions.count, 1)
    }

    func test_load_onFailure_transitionsToError() async {
        // Given a service that throws
        mockService.shouldThrow = true

        // When load is invoked
        await testSubject.load()

        // Then state is .error
        if case .error = testSubject.state {} else {
            XCTFail("Expected .error")
        }
    }

    // MARK: - Year grouping

    func test_transactionsByYear_groupsByYearCorrectly() async {
        // Given transactions across two years
        mockService.stubbedTransactions = [
            .fixture(date: date(year: 2026, month: 4, day: 17)),
            .fixture(date: date(year: 2026, month: 3, day: 28)),
            .fixture(date: date(year: 2025, month: 12, day: 1)),
            .fixture(date: date(year: 2025, month: 1, day: 15))
        ]

        // When load completes
        await testSubject.load()

        // Then transactions are grouped into two year buckets
        let grouped = testSubject.transactionsByYear
        XCTAssertEqual(grouped.count, 2)

        // And 2026 comes first (newest year)
        XCTAssertEqual(grouped[0].year, "2026")
        XCTAssertEqual(grouped[0].transactions.count, 2)

        XCTAssertEqual(grouped[1].year, "2025")
        XCTAssertEqual(grouped[1].transactions.count, 2)
    }

    func test_transactionsByYear_sortsWithinEachYearNewestFirst() async {
        // Given two transactions in the same year, out of order
        let older = FuelTransaction.fixture(date: date(year: 2026, month: 1, day: 1))
        let newer = FuelTransaction.fixture(date: date(year: 2026, month: 6, day: 1))

        mockService.stubbedTransactions = [older, newer]

        // When load completes
        await testSubject.load()

        // Then the newer transaction comes first within the year group
        let grouped = testSubject.transactionsByYear
        XCTAssertEqual(grouped.first?.transactions.first?.id, newer.id)
        XCTAssertEqual(grouped.first?.transactions.last?.id, older.id)
    }

    func test_transactionsByYear_whenStateIsIdle_returnsEmpty() {
        // Given no load has been called (state is .idle)

        // Then grouped output is empty
        XCTAssertTrue(testSubject.transactionsByYear.isEmpty)
    }

    func test_transactionsByYear_whenStateIsError_returnsEmpty() async {
        // Given a service that throws
        mockService.shouldThrow = true

        // When load fails
        await testSubject.load()

        // Then grouped output is empty
        XCTAssertTrue(testSubject.transactionsByYear.isEmpty)
    }

    // MARK: - Derived state

    func test_transactionCount_reflectsLoadedState() async {
        // Given three transactions
        mockService.stubbedTransactions = [
            .fixture(),
            .fixture(),
            .fixture()
        ]

        // When load completes
        await testSubject.load()

        // Then transactionCount is 3
        XCTAssertEqual(testSubject.transactionCount, 3)
    }

    func test_transactionCount_whenIdle_isZero() {
        XCTAssertEqual(testSubject.transactionCount, 0)
    }

    // MARK: - Refresh

    func test_refresh_delegatesToLoad() async {
        // Given stubbed data
        mockService.stubbedTransactions = [.fixture()]

        // When refresh is invoked
        await testSubject.refresh()

        // Then the service was called once
        XCTAssertEqual(mockService.getFuelTransactionsCallCount, 1)
    }
}
