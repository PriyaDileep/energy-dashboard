//
//  FuelTransaction+Formatting.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

extension FuelTransaction {

    // MARK: - Currency
    
    var formattedCost: String {
        totalCost.formatted(.currency(code: "AUD"))
    }

    var formattedCostAtPump: String {
        totalAtPump.formatted(.currency(code: "AUD"))
    }

    // MARK: - Volume

    var formattedLitres: String {
        String(format: "%.2fL", litres)
    }

    // MARK: - Date

    var dateTileMonth: String {
        date.formatted(.dateTime.month(.abbreviated))
    }

    var dateTileDay: String {
        date.formatted(.dateTime.day())
    }

    var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    var fullFormattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy 'at' h:mm a zzz"
        return dateFormatter.string(from: date)
    }

    // MARK: - Computed state

    var hasDiscount: Bool {
        totalCost < totalAtPump
    }

    var savingsAmount: Double {
        max(totalAtPump - totalCost, 0)
    }

    // MARK: - Sharing

    var shareText: String {
        """
        Fuel Receipt — \(stationSuburb)
        \(fullFormattedDate)

        Pump: \(pumpNumber)
        Fuel type: \(fuelType)
        Volume: \(formattedLitres)

        Total at pump: \(formattedCostAtPump)
        Total spend: \(formattedCost)
        \(savingsNote ?? "")

        \(paymentMethod)
        """
    }
    
}
