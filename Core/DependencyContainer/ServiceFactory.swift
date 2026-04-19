//
//  ServiceFactory.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

enum ServiceFactory {

    enum Environment {

        case demo

        case live
        
    }

    static func makeDataService(for environment: Environment) -> DataServiceProtocol {
        switch environment {
        case .demo:
            return DemoDataService()
        case .live:
            return DefaultDataService()
        }
    }
    
}
