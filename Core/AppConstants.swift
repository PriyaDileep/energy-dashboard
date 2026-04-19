//
//  AppConstants.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import Foundation


enum AppConstants {

    // MARK: - Behaviour

    enum Behaviour {
       
        static let dashboardPreviewCount = 2

        static let mockNetworkDelay: UInt64 = 600_000_000
    }

    // MARK: - Layout

    enum Layout {
        static let cardCornerRadius: CGFloat = 20
        static let cardPadding: CGFloat = 18
        static let cardSpacing: CGFloat = 14
        static let moduleHeaderPadding: CGFloat = 14

        static let pillCornerRadius: CGFloat = 18
        static let pillHorizontalPadding: CGFloat = 14
        static let pillVerticalPadding: CGFloat = 7

        static let dateTileSize: CGFloat = 44
        static let dateTileCornerRadius: CGFloat = 10

        static let mapCircleSize: CGFloat = 180

        static let iconButtonSize: CGFloat = 40
    }

    // MARK: - Strings

    enum Strings {
        static let appTitle = "OnRoad"

        static let greetingMorning = "Good morning"
        static let greetingAfternoon = "Good afternoon"
        static let greetingEvening = "Good evening"

        static let fuelSectionTitle = "Fuel"
        static let chargeSectionTitle = "Charge"
        static let offersSectionTitle = "Offers"

        static let fuelModuleTitle = "Recent transactions"
        static let chargeModuleTitle = "Recent sessions"
        static let fuelModuleSubtitle = "Last 30 days"
        static let chargeModuleSubtitle = "Last 30 days"

        static let viewAllTransactions = "View all transactions"
        static let viewAllSessions = "View all sessions"

        static let liveSession = "LIVE SESSION"
        static let inProgress = "In progress"

        static let paymentSummary = "Payment summary"
        static let sessionSummary = "Session summary"
        static let paidWith = "Paid with"

        static let addNote = "+ Add note"
        static let getDirections = "Get directions"

        static let emptyTransactions = "No recent transactions"
        static let emptySessions = "No recent sessions"
        static let errorTitle = "Something went wrong"
        static let errorRetry = "Try again"
    }

    // MARK: - JSON file names

    enum JSONFiles {
        static let fuelTransactions = "fuel_transactions"
        static let chargeSessions = "charge_sessions"
        static let storeOffers = "store_offers"
    }
}
