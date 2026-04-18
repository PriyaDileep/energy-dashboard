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

    // MARK: - Production networking shape (illustrative)

    /// The shape a real implementation would take.
    /// Left here as a comment-friendly reference to show architectural intent
    /// without actually executing network calls in a demo submission.
    ///
    /// ```
    /// private func get<T: Decodable>(path: String) async throws -> T {
    ///     let url = baseURL.appendingPathComponent(path)
    ///     let (data, response) = try await session.data(from: url)
    ///
    ///     guard let http = response as? HTTPURLResponse,
    ///           (200..<300).contains(http.statusCode) else {
    ///         throw URLError(.badServerResponse)
    ///     }
    ///
    ///     return try decoder.decode(T.self, from: data)
    /// }
    /// ```
    private func notImplemented() -> Never {
        fatalError("DefaultDataService is a production placeholder — not implemented.")
    }
}
