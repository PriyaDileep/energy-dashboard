//
//  ChargeSessionRowView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

//
//  ChargeSessionRowView.swift
//  EnergyDashboard
//

import SwiftUI

struct ChargeSessionRowView: View {

    // MARK: - Inputs

    let session: ChargeSession

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            topRow
            badgesRow
        }
        .padding(.horizontal, AppConstants.Layout.cardPadding)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    // MARK: - Subviews

    private var topRow: some View {
        HStack(spacing: 14) {
            DateTileView(session: session)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.locationName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                Text(session.sessionTimeDescription)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.secondaryText)
            }

            Spacer()

            costLabel
        }
    }

    @ViewBuilder
    private var costLabel: some View {
        if session.isActive {
            HStack(spacing: 2) {
                Text(session.formattedCost)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.chargeAccent)
                    .monospacedDigit()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.chargeAccent)
            }
            .accessibilityLabel("Cost currently \(session.formattedCost), still increasing")
        } else {
            Text(session.formattedCost)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)
                .monospacedDigit()
        }
    }

    private var badgesRow: some View {
        HStack(spacing: 6) {
            InfoBadgeView(
                session.formattedChargeRate,
                systemImageName: "bolt.fill",
                style: session.isActive ? .charge : .neutral
            )
            InfoBadgeView(
                session.formattedEnergy,
                systemImageName: "battery.75percent"
            )
            InfoBadgeView(
                session.formattedDuration,
                systemImageName: "clock"
            )
        }
        .padding(.leading, AppConstants.Layout.dateTileSize + 14)
    }

}

