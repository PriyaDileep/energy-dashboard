//
//  ChargeSession.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

struct ChargeSession: Identifiable, Hashable, Sendable, Codable {

    let id: UUID

    let locationName: String

    let bayIdentifier: String

    let address: String

    let date: Date

    let totalCost: Double

    let durationMinutes: Int

    let energyKWh: Double

    let chargeRateKW: Double

    let discount: Double

    let isActive: Bool

    let batteryPercentage: Int?

    let startingBatteryPercentage: Int?
    
    let targetBatteryPercentage: Int?
    
}
