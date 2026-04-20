//
//  FuelTransactionsListView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 20/4/2026.
//

import SwiftUI

struct FuelTransactionsListView: View {

    // MARK: - State

    @StateObject var viewModel: FuelTransactionsViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            ViewStateView(
                state: viewModel.state,
                emptyMessage: AppConstants.Strings.emptyTransactions,
                onRetry: { Task { await viewModel.load() } }
            ) { transactions in
                transactionList(transactions)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(AppColors.pageBackground)
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Subviews

    private func transactionList(_ transactions: [FuelTransaction]) -> some View {
        let sorted = transactions.sorted { $0.date > $1.date }

        return LazyVStack(spacing: 0) {
            ForEach(sorted) { transaction in
                NavigationLink(value: transaction) {
                    row(for: transaction)
                }
                .buttonStyle(.plain)

                if transaction.id != sorted.last?.id {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
    }

    private func row(for transaction: FuelTransaction) -> some View {
        HStack(spacing: 12) {
            Text(transaction.listRowDate)
                .font(.system(size: 15))
                .foregroundStyle(AppColors.primaryText)

            Spacer()

            Text(transaction.formattedCost)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)
                .monospacedDigit()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColors.tertiaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

// MARK: - Formatting helper

private extension FuelTransaction {

    private static let listRowDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy 'at' h:mm a"
        return formatter
    }()

    // Row date format — "17 Apr 2026 at 9:44 am".
    var listRowDate: String {
        Self.listRowDateFormatter.string(from: date)
    }
}
