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
    @State private var viewModelFactory: ViewModelFactory
    
    init() {
        let dataService = ServiceFactory.makeDataService(for: .demo)
        let factory = ViewModelFactory(dataService: dataService)
        _viewModelFactory = State(wrappedValue: factory)
    }
    
    var body: some Scene {
        WindowGroup {
            
            // DashboardView(viewModel: viewModelFactory.makeDashboardViewModel())
            
            Text("EnergyDashboard — Phase 5 complete")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
}
