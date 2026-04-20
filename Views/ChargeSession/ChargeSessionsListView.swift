//
//  ChargeSessionsListView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 20/4/2026.
//

import SwiftUI

struct ChargeSessionsListView: View {

    // MARK: - State

    @StateObject var viewModel: ChargeSessionsViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            ViewStateView(
                state: viewModel.state,
                emptyMessage: AppConstants.Strings.emptySessions,
                onRetry: { Task { await viewModel.load() } }
            ) { sessions in
                sessionList(sessions)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(AppColors.pageBackground)
        .navigationTitle("Charging sessions")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Subviews

    private func sessionList(_ sessions: [ChargeSession]) -> some View {
        let sorted = sessions.sorted { $0.date > $1.date }

        return LazyVStack(spacing: 0) {
            ForEach(sorted) { session in
                NavigationLink(value: session) {
                    row(for: session)
                }
                .buttonStyle(.plain)

                if session.id != sorted.last?.id {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
    }

    private func row(for session: ChargeSession) -> some View {
        HStack(spacing: 12) {
            Text(session.listRowDate)
                .font(.system(size: 15))
                .foregroundStyle(AppColors.primaryText)

            Spacer()

            if session.isActive {
                HStack(spacing: 2) {
                    Text(session.formattedCost)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.chargeAccent)
                        .monospacedDigit()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(AppColors.chargeAccent)
                }
            } else {
                Text(session.formattedCost)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
                    .monospacedDigit()
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColors.tertiaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(session.isActive ? "Active session. " : "")"
            + "\(session.listRowDate), \(session.formattedCost)"
        )
        .accessibilityHint("Opens session details")
    }
}

// MARK: - helper

private extension ChargeSession {

    private static let listRowDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy 'at' h:mm a"
        return formatter
    }()

    var listRowDate: String {
        Self.listRowDateFormatter.string(from: date)
    }
}
