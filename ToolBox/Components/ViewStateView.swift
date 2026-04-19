//
//  ViewStateView.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

struct ViewStateView<T, LoadedContent: View>: View {

    // MARK: - Inputs

    let state: ViewState<T>

    let isEmpty: (T) -> Bool

    let emptyMessage: String

    let onRetry: (() -> Void)?

    @ViewBuilder let loadedContent: (T) -> LoadedContent

    // MARK: - Body

    var body: some View {
        switch state {
        case .idle:
            // Idle is treated as loading visually — we haven't asked the user to do anything.
            loadingView

        case .loading:
            loadingView

        case .success(let value):
            if isEmpty(value) {
                emptyView
            } else {
                loadedContent(value)
            }

        case .error(let error):
            errorView(error: error)
        }
    }

    // MARK: - States

    private var loadingView: some View {
        HStack {
            ProgressView()
                .controlSize(.regular)
            Spacer()
        }
        .padding(.vertical, 32)
        .padding(.horizontal, AppConstants.Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 28))
                .foregroundStyle(AppColors.tertiaryText)
            Text(emptyMessage)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
    }

    private func errorView(error: Error) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(AppColors.offersAccent)

            Text(AppConstants.Strings.errorTitle)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)

            Text(error.localizedDescription)
                .font(.system(size: 12))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let onRetry {
                Button(action: onRetry) {
                    Text(AppConstants.Strings.errorRetry)
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Convenience for collection types

extension ViewStateView where T: Collection {

    /// Convenience init for collection types — `isEmpty` defaults to `\.isEmpty`.
    init(
        state: ViewState<T>,
        emptyMessage: String,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder loadedContent: @escaping (T) -> LoadedContent
    ) {
        self.state = state
        self.isEmpty = { $0.isEmpty }
        self.emptyMessage = emptyMessage
        self.onRetry = onRetry
        self.loadedContent = loadedContent
    }
}

// MARK: - Previews

#Preview("Loading") {
    ViewStateView<[String], Text>(
        state: .loading,
        emptyMessage: "No items"
    ) { items in
        Text(items.joined(separator: ", "))
    }
    .padding()
}

#Preview("Empty") {
    ViewStateView<[String], Text>(
        state: .success([]),
        emptyMessage: "No recent transactions"
    ) { items in
        Text(items.joined(separator: ", "))
    }
    .padding()
}

#Preview("Error") {
    ViewStateView<[String], Text>(
        state: .error(URLError(.notConnectedToInternet)),
        emptyMessage: "No items",
        onRetry: { print("retry tapped") }
    ) { items in
        Text(items.joined(separator: ", "))
    }
    .padding()
}
