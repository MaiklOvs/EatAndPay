//
//  TextTabBar.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI

/// Таб-бар в виде горизонтального списка текстовых кнопок
public struct TextTabBar: View {

    @State public var selectedIndex: Int
    public let tabs: [String]

    public init(selectedIndex: Int, tabs: [String]) {
        self._selectedIndex = State(initialValue: selectedIndex)
        self.tabs = tabs
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedIndex = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(title)
                                .font(DSTypography.tabBarTitle)
                                .foregroundStyle(
                                    selectedIndex == index
                                        ? DSColors.textPrimary
                                        : DSColors.textSecondary
                                )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab = 0

        var body: some View {
            VStack {
                TextTabBar(
                    selectedIndex: selectedTab,
                    tabs: ["Для тебя", "Каталог", "Скидки", "Избранное"]
                )
                Spacer()
            }
            .padding(.top, 16)
        }
    }

    return PreviewWrapper()
}
