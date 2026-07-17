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

    public init(searchText: Binding<String>, action: @escaping () -> Void) {
        self.action = action
        self.searchText = searchText
    }

    public var body: some View {
        HStack {
            Image(.search)
            TextField("Поиск", text: searchText)
                .onSubmit {
                    action()
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
    SearchBar(searchText: .constant("")) {}
        .padding()
}
