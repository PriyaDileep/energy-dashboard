//
//  FuelTransaction.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

struct FuelTransaction: Identifiable, Hashable, Sendable, Codable {

    let id: UUID

    let stationSuburb: String

    let date: Date

    let totalCost: Double

    let totalAtPump: Double

    let litres: Double

    let fuelType: String

    let pumpNumber: Int

    let savingsNote: String?

    let paymentMethod: String
    
}
