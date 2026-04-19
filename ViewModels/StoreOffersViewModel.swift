//
//  StoreOffersViewModel.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation
import Combine

@MainActor
final class StoreOffersViewModel: ObservableObject {

    @Published var state: ViewState<[StoreOffer]> = .idle

    var featuredOffer: StoreOffer? {
        guard case .success(let offers) = state else { return nil }
        return offers.first
    }

    var additionalOffers: [StoreOffer] {
        guard case .success(let offers) = state else { return [] }
        return Array(offers.dropFirst())
    }

    var offerCount: Int {
        guard case .success(let offers) = state else { return 0 }
        return offers.count
    }

    // MARK: - Dependencies

    private let dataService: DataServiceProtocol

    // MARK: - Init

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    func load() async {
        state = .loading

        do {
            let offers = try await dataService.getStoreOffers()
            state = .success(offers)
        } catch {
            state = .error(error)
        }
    }

    func refresh() async {
        await load()
    }
    
}
