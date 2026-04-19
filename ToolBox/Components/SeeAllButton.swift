//
//  SeeAllButton.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI


struct SeeAllButton: View {

    let label: String
    
    let action: () -> Void

    init(
        label: String = AppConstants.Strings.seeAll,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(Color.accentColor)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens the full list")
    }
    
}
