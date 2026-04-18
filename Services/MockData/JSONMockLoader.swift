//
//  JSONMockLoader.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation

enum JSONMockLoaderError: Error, LocalizedError {

    case fileNotFound(String)

    case decodingFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "JSON file '\(name).json' was not found in the bundle."
        case .decodingFailed(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        }
    }
}

enum JSONMockLoader {

    static func load<T: Decodable>(
        _ filename: String,
        as type: T.Type = T.self,
        bundle: Bundle = .main,
        simulateDelay: Bool = true
    ) async throws -> T {

        if simulateDelay {
            try? await Task.sleep(nanoseconds: AppConstants.Behaviour.mockNetworkDelay)
        }

        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw JSONMockLoaderError.fileNotFound(filename)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONMockLoaderError.decodingFailed(underlying: error)
        }
    }
}
