//
//  DefaultDataService.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

struct DefaultDataService: DataServiceProtocol {

    // MARK: - Dependencies

    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder

    // MARK: - Init

    init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://api.example.com/v1")!
    ) {
        self.session = session
        self.baseURL = baseURL

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    // MARK: - DataServiceProtocol

    func getFuelTransactions() async throws -> [FuelTransaction] {
        // Production: return try await get(path: "/fuel/transactions")
        fatalError("Not implemented — use DemoDataService for this submission.")
    }

    func getChargeSessions() async throws -> [ChargeSession] {
        // Production: return try await get(path: "/charge/sessions")
        fatalError("Not implemented — use DemoDataService for this submission.")
    }

    func getStoreOffers() async throws -> [StoreOffer] {
        // Production: return try await get(path: "/offers")
        fatalError("Not implemented — use DemoDataService for this submission.")
    }

    private func notImplemented() -> Never {
        fatalError("DefaultDataService is a production placeholder — not implemented.")
    }
}
