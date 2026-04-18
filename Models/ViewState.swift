//
//  ViewState.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

enum ViewState<T> {

    case idle

    case loading

    case success(T)
    
    case error(Error)
    
}
