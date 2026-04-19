//
//  DateTileView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct DateTileView: View {

    // MARK: - Inputs

    let upperLabel: String

    let lowerLabel: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 2) {
            Text(upperLabel.uppercased())
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(AppColors.secondaryText)
                .tracking(0.5)

            Text(lowerLabel)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)
                .monospacedDigit()
        }
        .frame(
            width: AppConstants.Layout.dateTileSize,
            height: AppConstants.Layout.dateTileSize
        )
        .background(
            Color(.systemGray6),
            in: RoundedRectangle(cornerRadius: AppConstants.Layout.dateTileCornerRadius)
        )
    }
}


extension DateTileView {
    
    init(transaction: FuelTransaction) {
        self.upperLabel = transaction.dateTileMonth
        self.lowerLabel = transaction.dateTileDay
    }
    
}


extension DateTileView {

    init(session: ChargeSession) {
        self.upperLabel = session.dateTileMonth
        self.lowerLabel = session.dateTileDay
    }
    
}
