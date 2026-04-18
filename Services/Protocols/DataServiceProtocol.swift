//
//  DataServiceProtocol.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation


protocol DataServiceProtocol {

    func getFuelTransactions() async throws -> [FuelTransaction]

    func getChargeSessions() async throws -> [ChargeSession]

    func getStoreOffers() async throws -> [StoreOffer]
    
}
