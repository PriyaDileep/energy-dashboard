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

            if activeSession != nil {
                liveBadge
            }
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

    private var liveBadge: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(AppColors.chargeAccent)
                .frame(width: 6, height: 6)
                .modifier(PulsingModifier())

            Text(AppConstants.Strings.liveBadge)
                .font(.system(size: 10, weight: .bold))
                .tracking(0.5)
                .foregroundStyle(AppColors.chargeAccent)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppColors.chargeAccentBackground, in: Capsule())
        .accessibilityLabel("Live charging session in progress")
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

private struct PulsingModifier: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 0.3 : 1.0)
            .animation(
                .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}
