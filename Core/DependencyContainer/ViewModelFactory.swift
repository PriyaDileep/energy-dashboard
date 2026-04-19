//
//  ViewModelFactory.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

@MainActor
final class ViewModelFactory {

    // MARK: - Dependencies

    private let dataService: DataServiceProtocol

    // MARK: - Init

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    // MARK: - View model creation

//    func makeDashboardViewModel() -> DashboardViewModel {
//        DashboardViewModel(dataService: dataService)
//    }
//
//    func makeFuelTransactionsViewModel() -> FuelTransactionsViewModel {
//        FuelTransactionsViewModel(dataService: dataService)
//    }
//
//    func makeChargeSessionsViewModel() -> ChargeSessionsViewModel {
//        ChargeSessionsViewModel(dataService: dataService)
//    }
//
//    func makeStoreOffersViewModel() -> StoreOffersViewModel {
//        StoreOffersViewModel(dataService: dataService)
//    }
//    
}
