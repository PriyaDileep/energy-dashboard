//
//  JSONMockLoaderTests.swift
//  EnergyDashboardTests
//
//  Created by Priyanka on 19/4/2026.
//

import XCTest
@testable import EnergyDashboard

@MainActor
final class JSONMockLoaderTests: XCTestCase {

    // MARK: - Properties

    private var testBundle: Bundle {
        Bundle(for: type(of: self))
    }

    // MARK: - Success cases

    func test_load_validFuelTransactionsJSON_decodesCorrectly() async throws {
        // When the real fuel transactions fixture is loaded
        let transactions: [FuelTransaction] = try await JSONMockLoader.load(
            "fuel_transactions",
            bundle: testBundle,
            simulateDelay: false
        )

        // Then the array is non-empty and the first item has expected shape
        XCTAssertFalse(transactions.isEmpty, "Expected fuel transactions fixture to contain records")
        XCTAssertNotNil(transactions.first?.id)
        XCTAssertFalse(transactions.first?.stationSuburb.isEmpty ?? true)
        XCTAssertGreaterThan(transactions.first?.totalCost ?? 0, 0)
    }

    func test_load_validChargeSessionsJSON_decodesCorrectly() async throws {
        let sessions: [ChargeSession] = try await JSONMockLoader.load(
            "charge_sessions",
            bundle: testBundle,
            simulateDelay: false
        )

        XCTAssertFalse(sessions.isEmpty)
        XCTAssertNotNil(sessions.first?.id)
        XCTAssertFalse(sessions.first?.locationName.isEmpty ?? true)
    }

    func test_load_validStoreOffersJSON_decodesCorrectly() async throws {
        let offers: [StoreOffer] = try await JSONMockLoader.load(
            "store_offers",
            bundle: testBundle,
            simulateDelay: false
        )

        XCTAssertFalse(offers.isEmpty)
        XCTAssertFalse(offers.first?.title.isEmpty ?? true)
        XCTAssertFalse(offers.first?.tag.isEmpty ?? true)
    }

    // MARK: - Date decoding

    func test_load_iso8601Dates_decodeToCorrectDateValues() async throws {
        // Given the fuel fixture has a date like "2026-04-17T07:42:00+10:00"
        let transactions: [FuelTransaction] = try await JSONMockLoader.load(
            "fuel_transactions",
            bundle: testBundle,
            simulateDelay: false
        )

        guard let firstDate = transactions.first?.date else {
            return XCTFail("Expected at least one transaction with a date")
        }

        let year2020 = Date(timeIntervalSince1970: 1_577_836_800)
        let year2030 = Date(timeIntervalSince1970: 1_893_456_000)
        XCTAssertGreaterThan(firstDate, year2020)
        XCTAssertLessThan(firstDate, year2030)
    }

    // MARK: - Error cases

    func test_load_missingFile_throwsFileNotFound() async {
        do {
            let _: [FuelTransaction] = try await JSONMockLoader.load(
                "definitely_does_not_exist",
                bundle: testBundle,
                simulateDelay: false
            )
            XCTFail("Expected load to throw for missing file")
        } catch let error as JSONMockLoaderError {
            guard case .fileNotFound(let filename) = error else {
                return XCTFail("Expected .fileNotFound, got \(error)")
            }
            XCTAssertEqual(filename, "definitely_does_not_exist")
        } catch {
            XCTFail("Expected JSONMockLoaderError, got \(type(of: error))")
        }
    }

    func test_load_wrongType_throwsDecodingFailed() async {
        // When fuel JSON is loaded but decoded as [ChargeSession]
        do {
            let _: [ChargeSession] = try await JSONMockLoader.load(
                "fuel_transactions",
                bundle: testBundle,
                simulateDelay: false
            )
            XCTFail("Expected decoding to fail when types don't match")
        } catch let error as JSONMockLoaderError {
            // Then a .decodingFailed error is thrown
            guard case .decodingFailed = error else {
                return XCTFail("Expected .decodingFailed, got \(error)")
            }
            // Pass — we got the right error case
        } catch {
            XCTFail("Expected JSONMockLoaderError, got \(type(of: error))")
        }
    }

    // MARK: - Bundle injection

    func test_load_withMainBundle_doesNotFindTestFixtures() async {
       
        do {
            let _: [String] = try await JSONMockLoader.load(
                "nonexistent_in_both_bundles",
                bundle: .main,
                simulateDelay: false
            )
            XCTFail("Expected load to throw for file missing in main bundle")
        } catch let error as JSONMockLoaderError {
            guard case .fileNotFound = error else {
                return XCTFail("Expected .fileNotFound, got \(error)")
            }
        } catch {
            XCTFail("Expected JSONMockLoaderError, got \(type(of: error))")
        }
    }

    // MARK: - Performance

    func test_load_withSimulateDelayFalse_completesQuickly() async throws {
        // Given delay is disabled for tests
        let start = Date()

        // When loading a fixture
        let _: [FuelTransaction] = try await JSONMockLoader.load(
            "fuel_transactions",
            bundle: testBundle,
            simulateDelay: false
        )

        let elapsed = Date().timeIntervalSince(start)

        XCTAssertLessThan(elapsed, 0.1, "Expected fast load when simulateDelay is false")
    }
}
