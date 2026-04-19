//
//  FuelTransactionDetailView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct FuelTransactionDetailView: View {

    // MARK: - Inputs

    let transaction: FuelTransaction

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                locationSection
                paymentSummaryCard
                paidWithCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .background(AppColors.pageBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: transaction.shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share receipt")
            }
        }
    }

    // MARK: - Hero section

    private var heroSection: some View {
        VStack(spacing: 10) {
            Text(transaction.formattedCost)
                .heroAmountStyle()

            Text(transaction.stationSuburb)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)

            Text(transaction.fullFormattedDate)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                InfoBadgeView(
                    "\(transaction.fuelType) · Pump \(transaction.pumpNumber)",
                    systemImageName: "fuelpump.fill"
                )
                InfoBadgeView(
                    AppConstants.Strings.addNote,
                    style: .charge
                )
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var locationSection: some View {
        VStack(spacing: 12) {
            Text("Nearby")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
                .tracking(0.8)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.91, green: 0.97, blue: 0.90),
                                Color(red: 1.00, green: 0.96, blue: 0.77)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(
                        width: AppConstants.Layout.mapCircleSize,
                        height: AppConstants.Layout.mapCircleSize
                    )

                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(AppColors.offersAccent)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                    )
            }

            Button {
                // Would open Maps with the station coordinate in production.
            } label: {
                Text(AppConstants.Strings.getDirections)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Payment summary card

    private var paymentSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(AppConstants.Strings.paymentSummary)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
                .tracking(0.4)

            VStack(spacing: 10) {
                summaryRow(label: "Pump", value: "\(transaction.pumpNumber)")
                summaryRow(label: "Fuel type", value: transaction.fuelType)
                summaryRow(label: "Volume", value: transaction.formattedLitres)

                if transaction.hasDiscount {
                    summaryRow(
                        label: "Total at pump",
                        value: transaction.formattedCostAtPump,
                        valueStyle: .strikethrough
                    )
                }

                summaryRow(
                    label: "Total spend",
                    value: transaction.formattedCost,
                    valueStyle: .bold
                )
            }

            if let savingsNote = transaction.savingsNote {
                Text(savingsNote)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.fuelAccent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
    }

    private var paidWithCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(AppConstants.Strings.paidWith)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
                .tracking(0.4)

            HStack(spacing: 12) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.chargeAccent)
                    .frame(width: 40, height: 40)
                    .background(AppColors.chargeAccentBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(transaction.paymentMethod)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)

                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
    }

    // MARK: - Helpers

    private enum ValueStyle {
        case normal
        case bold
        case strikethrough
    }

    @ViewBuilder
    private func summaryRow(
        label: String,
        value: String,
        valueStyle: ValueStyle = .normal
    ) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(AppColors.secondaryText)

            Spacer()

            Group {
                switch valueStyle {
                case .normal:
                    Text(value)
                        .font(.system(size: 15, weight: .medium))
                case .bold:
                    Text(value)
                        .font(.system(size: 17, weight: .bold))
                case .strikethrough:
                    Text(value)
                        .font(.system(size: 15))
                        .foregroundStyle(AppColors.tertiaryText)
                        .strikethrough()
                }
            }
            .foregroundStyle(
                valueStyle == .strikethrough
                    ? AppColors.tertiaryText
                    : AppColors.primaryText
            )
            .monospacedDigit()
        }
    }
}

