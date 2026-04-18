//
//  AppTextStyles.swift
//  EnergyDashboard
//
//  Created by Priyanka on 19/4/2026.
//

import SwiftUI

// MARK: - Modifiers

private struct HeroAmountStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 48, weight: .bold, design: .rounded))
            .foregroundStyle(AppColors.primaryText)
            .monospacedDigit()
    }
}


private struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(AppColors.primaryText)
    }
}


private struct ModuleTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(AppColors.primaryText)
    }
}


private struct CaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .foregroundStyle(AppColors.secondaryText)
    }
}

// MARK: - Convenience extensions

extension View {

    func heroAmountStyle() -> some View {
        modifier(HeroAmountStyle())
    }

    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }

    func moduleTitleStyle() -> some View {
        modifier(ModuleTitleStyle())
    }

    func captionStyle() -> some View {
        modifier(CaptionStyle())
    }
}
