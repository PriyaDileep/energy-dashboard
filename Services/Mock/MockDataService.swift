//
//  MockDataService.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

final class MockDataService: DataServiceProtocol {

    // MARK: - Stubbed data

    var stubbedTransactions: [FuelTransaction] = []
    var stubbedSessions: [ChargeSession] = []
    var stubbedOffers: [StoreOffer] = []

    // MARK: - Failure injection

    var shouldThrow: Bool = false


    private(set) var getFuelTransactionsCallCount = 0
    private(set) var getChargeSessionsCallCount = 0
    private(set) var getStoreOffersCallCount = 0

    // MARK: - DataServiceProtocol

    func getFuelTransactions() async throws -> [FuelTransaction] {
        getFuelTransactionsCallCount += 1
        if shouldThrow { throw MockError.forced }
        return stubbedTransactions
    }

    func getChargeSessions() async throws -> [ChargeSession] {
        getChargeSessionsCallCount += 1
        if shouldThrow { throw MockError.forced }
        return stubbedSessions
    }

    func getStoreOffers() async throws -> [StoreOffer] {
        getStoreOffersCallCount += 1
        if shouldThrow { throw MockError.forced }
        return stubbedOffers
    }
}

// MARK: - Mock error

enum MockError: Error {
    case forced
}
