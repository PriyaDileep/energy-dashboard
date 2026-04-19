//
//  FuelTransactionsModuleView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct FuelTransactionsModuleView: View {

    // MARK: - Inputs

    let state: ViewState<[FuelTransaction]>
    let recentTransactions: [FuelTransaction]
    let onRetry: () -> Void


    var body: some View {
        ModuleCardView {
            header
        } content: {
            ViewStateView(
                state: state,
                emptyMessage: AppConstants.Strings.emptyTransactions,
                onRetry: onRetry
            ) { _ in
                transactionRows
            }
        } footer: {
            if !recentTransactions.isEmpty {
                viewAllFooter
            }
        }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack(spacing: 10) {
            brandIcon

            VStack(alignment: .leading, spacing: 2) {
                Text(AppConstants.Strings.fuelModuleTitle)
                    .moduleTitleStyle()
                Text(AppConstants.Strings.fuelModuleSubtitle)
                    .captionStyle()
            }

            Spacer()
        }
    }
    
    private var brandIcon: some View {
        Circle()
            .fill(AppColors.fuelAccentBackground)
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "fuelpump.fill")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.fuelAccent)
            )
    }

    private var transactionRows: some View {
        VStack(spacing: 0) {
            ForEach(recentTransactions) { transaction in
                NavigationLink(value: transaction) {
                    FuelTransactionRowView(transaction: transaction)
                }
                .buttonStyle(.plain)

                if transaction.id != recentTransactions.last?.id {
                    Divider()
                        .padding(.leading, AppConstants.Layout.cardPadding + 44 + 14)
                }
            }
        }
    }

    private var viewAllFooter: some View {
        Button {
        } label: {
            Text(AppConstants.Strings.viewAllTransactions)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(alignment: .top) {
                    Divider()
                }
        }
        .buttonStyle(.plain)
    }
}

