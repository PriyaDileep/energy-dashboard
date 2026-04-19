//
//  ModuleCardView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct ModuleCardView<Header: View, Content: View, Footer: View>: View {

    // MARK: - Slots

    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header()
                .padding(.horizontal, AppConstants.Layout.cardPadding)
                .padding(.top, AppConstants.Layout.moduleHeaderPadding)
                .padding(.bottom, 10)

            content()

            footer()
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

extension ModuleCardView where Footer == EmptyView {

    /// Creates a module card without a footer slot.
    /// Callers that don't need a "View all" row can omit the closure entirely.
    init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
        self.footer = { EmptyView() }
    }
}

// MARK: - Previews

#Preview("With footer") {
    ModuleCardView {
        HStack {
            Circle()
                .fill(AppColors.fuelAccentBackground)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "fuelpump.fill")
                        .foregroundStyle(AppColors.fuelAccent)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("Recent transactions").moduleTitleStyle()
                Text("Last 30 days").captionStyle()
            }
            Spacer()
        }
    } content: {
        VStack(spacing: 0) {
            ForEach(0..<2) { _ in
                HStack {
                    Text("Newstead")
                    Spacer()
                    Text("$47.86")
                }
                .padding()
                Divider()
            }
        }
    } footer: {
        Text("View all transactions")
            .foregroundStyle(Color.accentColor)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) { Divider() }
    }
    .padding()
    .background(AppColors.pageBackground)
}

#Preview("Header only") {
    ModuleCardView {
        Text("Simple card").moduleTitleStyle()
    } content: {
        Text("Body content here")
            .padding()
    }
    .padding()
    .background(AppColors.pageBackground)
}
