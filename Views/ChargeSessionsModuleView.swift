//
//  ChargeSessionsModuleView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct ChargeSessionsModuleView: View {

    // MARK: - Inputs

    let state: ViewState<[ChargeSession]>
    let recentSessions: [ChargeSession]
    let activeSession: ChargeSession?
    let onRetry: () -> Void

    // MARK: - Body

    var body: some View {
        ModuleCardView {
            header
        } content: {
            ViewStateView(
                state: state,
                emptyMessage: AppConstants.Strings.emptySessions,
                onRetry: onRetry
            ) { _ in
                sessionRows
            }
        } footer: {
            if !recentSessions.isEmpty {
                viewAllFooter
            }
        }
    }

    // MARK: - Subviews
    
    private var header: some View {
        HStack(spacing: 10) {
            brandIcon

            VStack(alignment: .leading, spacing: 2) {
                Text(AppConstants.Strings.chargeModuleTitle)
                    .moduleTitleStyle()
                Text(AppConstants.Strings.chargeModuleSubtitle)
                    .captionStyle()
            }

            Spacer()
        }
    }

    private var brandIcon: some View {
        Circle()
            .fill(AppColors.chargeAccentBackground)
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "bolt.fill")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.chargeAccent)
            )
    }

    private var sessionRows: some View {
        VStack(spacing: 0) {
            ForEach(recentSessions) { session in
                NavigationLink(value: session) {
                    ChargeSessionRowView(session: session)
                }
                .buttonStyle(.plain)

                if session.id != recentSessions.last?.id {
                    Divider()
                        .padding(.leading, AppConstants.Layout.cardPadding + 44 + 14)
                }
            }
        }
    }

    private var viewAllFooter: some View {
        Button {
            // Navigation to full list,  out of scope for this
        } label: {
            Text(AppConstants.Strings.viewAllSessions)
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
