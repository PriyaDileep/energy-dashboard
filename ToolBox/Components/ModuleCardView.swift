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
