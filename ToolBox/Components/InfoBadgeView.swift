//
//  InfoBadgeView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI


struct InfoBadgeView: View {

    // MARK: - Style

    enum Style {
        case neutral
        case fuel
        case charge
        case positive

        var foreground: Color {
            switch self {
            case .neutral:  return AppColors.primaryText
            case .fuel:     return AppColors.fuelAccent
            case .charge:   return AppColors.chargeAccent
            case .positive: return AppColors.positive
            }
        }

        var background: Color {
            switch self {
            case .neutral:  return Color(.systemGray5)
            case .fuel:     return AppColors.fuelAccentBackground
            case .charge:   return AppColors.chargeAccentBackground
            case .positive: return AppColors.positiveBackground
            }
        }
    }

    // MARK: - Inputs

    let systemImageName: String?
    let text: String
    let style: Style

    // MARK: - Init

    init(
        _ text: String,
        systemImageName: String? = nil,
        style: Style = .neutral
    ) {
        self.text = text
        self.systemImageName = systemImageName
        self.style = style
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 4) {
            if let systemImageName {
                Image(systemName: systemImageName)
                    .font(.system(size: 11, weight: .medium))
            }
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(style.foreground)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(style.background, in: Capsule())
    }
}

// MARK: - Previews

#Preview("Charge session badges") {
    HStack(spacing: 6) {
        InfoBadgeView("50 kW", systemImageName: "bolt.fill", style: .charge)
        InfoBadgeView("72%", systemImageName: "battery.75percent", style: .positive)
        InfoBadgeView("18 min", systemImageName: "clock")
    }
    .padding()
}

#Preview("Detail view badges") {
    VStack(alignment: .leading, spacing: 8) {
        InfoBadgeView("Unleaded · Pump 4", systemImageName: "fuelpump.fill")
        InfoBadgeView("+ Add note", style: .charge)
        InfoBadgeView("LIVE", style: .positive)
    }
    .padding()
}

#Preview("All styles") {
    VStack(alignment: .leading, spacing: 8) {
        InfoBadgeView("Neutral", systemImageName: "info.circle")
        InfoBadgeView("Fuel accent", systemImageName: "fuelpump.fill", style: .fuel)
        InfoBadgeView("Charge accent", systemImageName: "bolt.fill", style: .charge)
        InfoBadgeView("Positive", systemImageName: "checkmark.circle.fill", style: .positive)
        InfoBadgeView("No icon", style: .neutral)
    }
    .padding()
}
