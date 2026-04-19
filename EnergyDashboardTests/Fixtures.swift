//
//  Fixtures.swift
//  EnergyDashboardTests
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation
@testable import EnergyDashboard

// MARK: - FuelTransaction fixture

extension FuelTransaction {

    static func fixture(
        id: UUID = UUID(),
        stationSuburb: String = "Newstead",
        date: Date = Date(timeIntervalSince1970: 1_745_000_000),
        totalCost: Double = 47.86,
        totalAtPump: Double = 49.10,
        litres: Double = 30.98,
        fuelType: String = "Unleaded",
        pumpNumber: Int = 4,
        savingsNote: String? = "Test saving applied",
        paymentMethod: String = "Paid with Visa"
    ) -> FuelTransaction {
        FuelTransaction(
            id: id,
            stationSuburb: stationSuburb,
            date: date,
            totalCost: totalCost,
            totalAtPump: totalAtPump,
            litres: litres,
            fuelType: fuelType,
            pumpNumber: pumpNumber,
            savingsNote: savingsNote,
            paymentMethod: paymentMethod
        )
    }
    
}

// MARK: - ChargeSession fixture

extension ChargeSession {

    static func fixture(
        id: UUID = UUID(),
        locationName: String = "Milton DC Hub",
        bayIdentifier: String = "Bay 2",
        address: String = "45 Cribb St, Milton QLD 4064",
        date: Date = Date(timeIntervalSince1970: 1_745_000_000),
        totalCost: Double = 14.60,
        durationMinutes: Int = 65,
        energyKWh: Double = 27.3,
        chargeRateKW: Double = 50.0,
        discount: Double = 1.48,
        isActive: Bool = false,
        batteryPercentage: Int? = nil,
        startingBatteryPercentage: Int? = nil,
        targetBatteryPercentage: Int? = nil
    ) -> ChargeSession {
        ChargeSession(
            id: id,
            locationName: locationName,
            bayIdentifier: bayIdentifier,
            address: address,
            date: date,
            totalCost: totalCost,
            durationMinutes: durationMinutes,
            energyKWh: energyKWh,
            chargeRateKW: chargeRateKW,
            discount: discount,
            isActive: isActive,
            batteryPercentage: batteryPercentage,
            startingBatteryPercentage: startingBatteryPercentage,
            targetBatteryPercentage: targetBatteryPercentage
        )
    }
    
}

// MARK: - StoreOffer fixture

extension StoreOffer {

    static func fixture(
        id: UUID = UUID(),
        tag: String = "For you",
        title: String = "4¢/L off fuel",
        subtitle: String = "Scan to redeem at any station",
        systemImageName: String = "fuelpump.fill",
        expiryDate: Date = Date(timeIntervalSince1970: 1_750_000_000)
    ) -> StoreOffer {
        StoreOffer(
            id: id,
            tag: tag,
            title: title,
            subtitle: subtitle,
            systemImageName: systemImageName,
            expiryDate: expiryDate
        )
    }
    
}
