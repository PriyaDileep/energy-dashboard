//
//  ChargeSessionsViewModel.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation
import Combine

@MainActor
final class ChargeSessionsViewModel: ObservableObject {

    // MARK: - State

    // The full list of charge sessions, active and completed.
    @Published var state: ViewState<[ChargeSession]> = .idle

    // MARK: - Derived state

    // The currently-active charging session, if one exists.
    var activeSession: ChargeSession? {
        guard case .success(let sessions) = state else { return nil }
        return sessions.first(where: { $0.isActive })
    }

    // All completed sessions, sorted newest-first.
    var completedSessions: [ChargeSession] {
        guard case .success(let sessions) = state else { return [] }
        return sessions
            .filter { !$0.isActive }
            .sorted { $0.date > $1.date }
    }

    // Completed sessions grouped by year, newest year first.
   
    var sessionsByYear: [(year: String, sessions: [ChargeSession])] {
        let grouped = Dictionary(grouping: completedSessions) { session in
            session.date.formatted(.dateTime.year())
        }

        return grouped
            .map { (year, sessions) in
                (year: year, sessions: sessions.sorted { $0.date > $1.date })
            }
            .sorted { $0.year > $1.year }
    }

    var sessionCount: Int {
        guard case .success(let sessions) = state else { return 0 }
        return sessions.count
    }

    // MARK: - Dependencies

    private let dataService: DataServiceProtocol

    // MARK: - Init

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    // MARK: - Actions

    func load() async {
        state = .loading

        do {
            let sessions = try await dataService.getChargeSessions()
            state = .success(sessions)
        } catch {
            state = .error(error)
        }
    }

    func refresh() async {
        await load()
    }
    
}
