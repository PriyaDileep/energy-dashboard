//
//  EnergyDashboardApp.swift
//  EnergyDashboard
//
//  Created by Priyanka on 18/4/2026.
//

import SwiftUI

@main
struct EnergyDashboardApp: App {
    
    // To switch to production, change .demo to .live
    private let viewModelFactory: ViewModelFactory
    
    init() {
        let dataService = ServiceFactory.makeDataService(for: .demo)
        self.viewModelFactory = ViewModelFactory(dataService: dataService)
    }
    
    var body: some Scene {
        WindowGroup {
            DashboardView(
                viewModel: viewModelFactory.makeDashboardViewModel(),
                viewModelFactory: viewModelFactory
            )
        }
    }
    
}
