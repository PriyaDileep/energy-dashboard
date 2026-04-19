//
//  DashboardView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct DashboardView: View {

    // MARK: - State

    @StateObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Layout.cardSpacing) {
                    greetingHeader

                    fuelSection
                    chargeSection
                    offersSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(AppColors.pageBackground)
            .navigationTitle(AppConstants.Strings.appTitle)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.load()
            }
            .navigationDestination(for: FuelTransaction.self) { transaction in
                FuelTransactionDetailView(transaction: transaction)
            }
            .navigationDestination(for: ChargeSession.self) { session in
                ChargeSessionDetailView(session: session)
            }
            .navigationDestination(for: StoreOffer.self) { offer in
                Text(offer.title)
                    .font(.title)
                    .navigationTitle(offer.tag)
            }
        }
    }

    // MARK: - Sections
    
    private var greetingHeader: some View {
        VStack(spacing: 2) {
            Text(timeBasedGreeting)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.secondaryText)
            Text("Priya")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    private var fuelSection: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(AppConstants.Strings.fuelSectionTitle)
                    .sectionTitleStyle()
                Spacer()
                SeeAllButton {
                    // Navigation to full fuel list — out of scope for this submission,
                    // wiring would be: path.append(FuelTransactionsListDestination.self)
                }
            }

            FuelTransactionsModuleView(
                state: viewModel.fuelState,
                recentTransactions: viewModel.recentFuelTransactions,
                onRetry: { Task { await viewModel.load() } }
            )
        }
    }

    
    private var chargeSection: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(AppConstants.Strings.chargeSectionTitle)
                    .sectionTitleStyle()
                Spacer()
                SeeAllButton { }
            }

            ChargeSessionsModuleView(
                state: viewModel.chargeState,
                recentSessions: viewModel.recentChargeSessions,
                activeSession: viewModel.activeSession,
                onRetry: { Task { await viewModel.load() } }
            )
        }
    }

   
    private var offersSection: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(AppConstants.Strings.offersSectionTitle)
                    .sectionTitleStyle()
                Spacer()
                SeeAllButton { }
            }

            StoreOffersModuleView(
                state: viewModel.offersState,
                featuredOffer: viewModel.featuredOffer,
                onRetry: { Task { await viewModel.load() } }
            )
        }
    }

    // MARK: - Helpers
    
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12:  return AppConstants.Strings.greetingMorning
        case 12..<17: return AppConstants.Strings.greetingAfternoon
        default:      return AppConstants.Strings.greetingEvening
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardView(
        viewModel: DashboardViewModel(dataService: DemoDataService())
    )
}
