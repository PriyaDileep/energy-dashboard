//
//  FuelTransactionsViewModel.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation
import Combine

@MainActor
final class FuelTransactionsViewModel: ObservableObject {
    
    @Published var state: ViewState<[FuelTransaction]> = .idle
    
    var transactionsByYear: [(year: String, transactions: [FuelTransaction])] {
        guard case .success(let transactions) = state else { return [] }
        
        // Group by year string (e.g. "2026")
        let grouped = Dictionary(grouping: transactions) { transaction in
            transaction.date.formatted(.dateTime.year())
        }
        
        // Sort each group's transactions newest-first, then sort groups newest-year-first
        return grouped
            .map { (year, txns) in
                (year: year, transactions: txns.sorted { $0.date > $1.date })
            }
            .sorted { $0.year > $1.year }
    }
    
    /// Total number of transactions — handy for empty-state copy and test assertions.
    var transactionCount: Int {
        guard case .success(let transactions) = state else { return 0 }
        return transactions.count
    }
    
    // MARK: - Dependencies
    
    private let dataService: DataServiceProtocol
    
    // MARK: - Init
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    // MARK: - Actions
    
    /// Loads the full transaction history.
    func load() async {
        state = .loading
        
        do {
            let transactions = try await dataService.getFuelTransactions()
            state = .success(transactions)
        } catch {
            state = .error(error)
        }
    }
    
    // used for pull-to-refresh on the list screen.
    func refresh() async {
        await load()
    }
}
