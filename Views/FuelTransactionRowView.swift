//
//  FuelTransactionRowView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct FuelTransactionRowView: View {

    // MARK: - Inputs

    let transaction: FuelTransaction

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            DateTileView(transaction: transaction)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.stationSuburb)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                Text(transaction.formattedTime)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.secondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(transaction.formattedCost)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
                    .monospacedDigit()
                Text(transaction.formattedLitres)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.secondaryText)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, AppConstants.Layout.cardPadding)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        
    }

}
