//
//  ChargeSessionDetailView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct ChargeSessionDetailView: View {

    // MARK: - Inputs

    let session: ChargeSession

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection

                if session.isActive, session.batteryProgress != nil {
                    batteryProgressCard
                }

                locationSection
                sessionSummaryCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .background(AppColors.pageBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: session.shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share session receipt")
            }
        }
    }

    // MARK: - Hero section

    private var heroSection: some View {
        VStack(spacing: 10) {
            if session.isActive {
                liveIndicator
            }

            Text(session.formattedCost)
                .heroAmountStyle()

            Text(session.locationName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)

            Text(session.sessionTimeDescription)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
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
                    AppConstants.Strings.addNote,
                    style: .charge
                )
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var liveIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(AppColors.chargeAccent)
                .frame(width: 6, height: 6)
                //.modifier(DetailPulsingModifier())

            Text(AppConstants.Strings.liveSession)
                .font(.system(size: 11, weight: .bold))
                .tracking(0.8)
        }
        .foregroundStyle(AppColors.chargeAccent)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(AppColors.chargeAccentBackground, in: Capsule())
    }

    // MARK: - Battery progress card

    private var batteryProgressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Battery level")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                Spacer()
                if let current = session.batteryPercentage {
                    Text("\(current)%")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.chargeAccent)
                        .monospacedDigit()
                }
            }

            batteryProgressBar

            HStack {
                if let starting = session.startingBatteryPercentage {
                    Text("\(starting)% on arrival")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.secondaryText)
                }
                Spacer()
                if let target = session.targetBatteryPercentage {
                    Text("Target: \(target)%")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
    }

    private var batteryProgressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColors.chargeAccentBackground)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.chargeAccent, Color(red: 0.22, green: 0.74, blue: 0.97)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * (session.batteryProgress ?? 0))
                    .animation(.easeInOut(duration: 0.4), value: session.batteryProgress)
            }
        }
        .frame(height: 10)
    }

    // MARK: - Location section

    private var locationSection: some View {
        VStack(spacing: 12) {
            Text("Station")
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
                    .background(Circle().fill(Color.white).frame(width: 12, height: 12))
            }
            .accessibilityLabel("Location of \(session.locationName)")

            Button {
                // Apple Maps integration in production.
            } label: {
                Text(AppConstants.Strings.getDirections)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Session summary card

    private var sessionSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(AppConstants.Strings.sessionSummary)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
                .tracking(0.4)

            VStack(spacing: 10) {
                summaryRow(label: "Charge rate", value: session.formattedChargeRate)
                summaryRow(label: "Energy added", value: session.formattedEnergy)
                summaryRow(label: "Duration", value: session.formattedDuration)
                summaryRow(
                    label: session.isActive ? "Est. cost" : "Cost",
                    value: session.formattedCost,
                    valueStyle: .bold
                )

                if session.hasDiscount {
                    summaryRow(
                        label: "Discount",
                        value: session.formattedDiscount,
                        valueStyle: .positive
                    )
                }
            }

            if session.hasDiscount {
                Text("Member discount applied")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.positive)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
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
        case positive
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

            switch valueStyle {
            case .normal:
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                    .monospacedDigit()
            case .bold:
                Text(value)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                    .monospacedDigit()
            case .positive:
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.positive)
                    .monospacedDigit()
            }
        }
    }
}

//private struct DetailPulsingModifier: ViewModifier {
//    @State private var isPulsing = false
//
//    func body(content: Content) -> some View {
//        content
//            .opacity(isPulsing ? 0.3 : 1.0)
//            .animation(
//                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
//                value: isPulsing
//            )
//            .onAppear { isPulsing = true }
//    }
//}
