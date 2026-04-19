//
//  Untitled.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

extension ChargeSession {

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy 'at' h:mm a zzz"
        return formatter
    }()
    
    // MARK: - Currency

    var formattedCost: String {
        totalCost.formatted(.currency(code: "AUD"))
    }

    var formattedDiscount: String {
        "-" + discount.formatted(.currency(code: "AUD"))
    }

    // MARK: - Energy & rate

    var formattedEnergy: String {
        String(format: "%.1f kWh", energyKWh)
    }

    var formattedChargeRate: String {
        String(format: "%.0f kW", chargeRateKW)
    }

    // MARK: - Duration

    var formattedDuration: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60

        if hours == 0 {
            return "\(minutes) min"
        } else {
            return "\(hours)h \(minutes)m"
        }
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
        Self.fullDateFormatter.string(from: date)
    }

    var sessionTimeDescription: String {
        if isActive {
            let relative = date.formatted(.relative(presentation: .named))
            return "Started \(relative) · \(bayIdentifier)"
        } else {
            return formattedTime
        }
    }

    // MARK: - Battery progress

    var batteryProgress: Double? {
        guard let current = batteryPercentage,
              let start = startingBatteryPercentage,
              let target = targetBatteryPercentage,
              target > start else {
            return nil
        }

        let progress = Double(current - start) / Double(target - start)
        return min(max(progress, 0), 1)
    }

    var hasDiscount: Bool {
        discount > 0
    }

    var shareText: String {
        """
        Charge Session Receipt — \(locationName)
        \(fullFormattedDate)

        Bay: \(bayIdentifier)
        Duration: \(formattedDuration)
        Energy added: \(formattedEnergy)
        Charge rate: \(formattedChargeRate)

        Total cost: \(formattedCost)
        \(hasDiscount ? "Discount applied: \(formattedDiscount)" : "")
        """
    }
    
}
