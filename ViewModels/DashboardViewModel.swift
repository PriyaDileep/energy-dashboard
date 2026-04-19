//
//  DashboardViewModel.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: - State

    @Published var fuelState: ViewState<[FuelTransaction]> = .idle

    @Published var chargeState: ViewState<[ChargeSession]> = .idle

    @Published var offersState: ViewState<[StoreOffer]> = .idle

    // MARK: - Derived state

    var recentFuelTransactions: [FuelTransaction] {
        guard case .success(let transactions) = fuelState else { return [] }
        return Array(transactions.prefix(AppConstants.Behaviour.dashboardPreviewCount))
    }

    var recentChargeSessions: [ChargeSession] {
        guard case .success(let sessions) = chargeState else { return [] }
        return Array(sessions.prefix(AppConstants.Behaviour.dashboardPreviewCount))
    }

    var activeSession: ChargeSession? {
        guard case .success(let sessions) = chargeState else { return nil }
        return sessions.first(where: { $0.isActive })
    }

    var featuredOffer: StoreOffer? {
        guard case .success(let offers) = offersState else { return nil }
        return offers.first
    }

    // MARK: - Dependencies

    private let dataService: DataServiceProtocol

    // MARK: - Init

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    // MARK: - Actions

    func load() async {
        fuelState = .loading
        chargeState = .loading
        offersState = .loading
        
        // Fire all three requests in parallel.
        async let fuelTask = dataService.getFuelTransactions()
        async let chargeTask = dataService.getChargeSessions()
        async let offersTask = dataService.getStoreOffers()
        
        do {
            fuelState = .success(try await fuelTask)
        } catch {
            fuelState = .error(error)
        }
        
        do {
            chargeState = .success(try await chargeTask)
        } catch {
            chargeState = .error(error)
        }
        
        do {
            offersState = .success(try await offersTask)
        } catch {
            offersState = .error(error)
        }
    }

    func refresh() async {
        await load()
    }

}
