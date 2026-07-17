//
//  SearchBar.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 16.07.2026.
//

import SwiftUI

/// Бар поиска

public struct SearchBar: View {

    private let action: () -> Void

    private let searchText: Binding<String>

    @Binding private var isFocused: Bool
    @FocusState private var focusState: Bool

    public init(
        searchText: Binding<String>,
        isFocused: Binding<Bool>,
        action: @escaping () -> Void
    ) {
        self.searchText = searchText
        self._isFocused = isFocused
        self.action = action
    }

    public var body: some View {
        HStack {
            Image(.search)
            TextField("Поиск", text: searchText)
                .focused($focusState)
                .onSubmit { action() }
                .onChange(of: focusState) { _, newValue in
                    isFocused = newValue
                }
                .onChange(of: isFocused) { _, newValue in
                    focusState = newValue
                }
        }
        .padding(10)
        .background(DSColors.searchBar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color(red: 151/255, green: 151/255, blue: 175/255, opacity: 0.3),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    SearchBar(
        searchText: .constant(""),
        isFocused: .constant(false)
    ) {}
        .padding()
}
