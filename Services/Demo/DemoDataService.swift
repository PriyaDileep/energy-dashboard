//
//  DemoDataService.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

struct DemoDataService: DataServiceProtocol {

    func getFuelTransactions() async throws -> [FuelTransaction] {
        try await JSONMockLoader.load(AppConstants.JSONFiles.fuelTransactions)
    }

    func getChargeSessions() async throws -> [ChargeSession] {
        try await JSONMockLoader.load(AppConstants.JSONFiles.chargeSessions)
    }

    func getStoreOffers() async throws -> [StoreOffer] {
        try await JSONMockLoader.load(AppConstants.JSONFiles.storeOffers)
    }
    
}
