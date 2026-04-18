//
//  StoreOffer.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

struct StoreOffer: Identifiable, Hashable, Sendable, Codable {

    let id: UUID

    let tag: String

    let title: String

    let subtitle: String

    let systemImageName: String

    let expiryDate: Date
    
}
