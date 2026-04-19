//
//  StoreOffersModuleView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct StoreOffersModuleView: View {

    // MARK: - Inputs

    let state: ViewState<[StoreOffer]>
    let featuredOffer: StoreOffer?
    let onRetry: () -> Void

    // MARK: - Body

    var body: some View {
        ModuleCardView {
            header
        } content: {
            ViewStateView(
                state: state,
                emptyMessage: "No offers available",
                onRetry: onRetry
            ) { _ in
                offerContent
            }
        }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack(spacing: 10) {
            brandIcon

            VStack(alignment: .leading, spacing: 2) {
                Text("Featured offer")
                    .moduleTitleStyle()
                Text("Tap to redeem")
                    .captionStyle()
            }

            Spacer()
        }
    }

    private var brandIcon: some View {
        Circle()
            .fill(AppColors.offersAccentBackground)
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "gift.fill")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.offersAccent)
            )
    }

    @ViewBuilder
    private var offerContent: some View {
        if let offer = featuredOffer {
            NavigationLink(value: offer) {
                offerRow(for: offer)
            }
            .buttonStyle(.plain)
        } else {
            EmptyView()
        }
    }

    private func offerRow(for offer: StoreOffer) -> some View {
        HStack(spacing: 14) {
    
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.offersAccentBackground, Color(red: 1.00, green: 0.80, blue: 0.80)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)

                Image(systemName: offer.systemImageName)
                    .font(.system(size: 28))
                    .foregroundStyle(AppColors.offersAccent)
            }

            VStack(alignment: .leading, spacing: 4) {
                // Small bold tag — "For you", "Limited time", "Member exclusive".
                Text(offer.tag.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(AppColors.offersAccent)
                    .tracking(0.8)

                Text(offer.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)

                Text(offer.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColors.tertiaryText)
        }
        .padding(.horizontal, AppConstants.Layout.cardPadding)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(offer.tag). \(offer.title). \(offer.subtitle)")
        .accessibilityHint("Opens offer details")
    }
}
