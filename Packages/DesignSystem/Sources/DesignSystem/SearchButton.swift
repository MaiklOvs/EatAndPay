//
//  SearchButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI

/// Кнопка поиска

public struct SearchButton: View {

    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Image(.search)
                    .frame(width: 50, height: 50)
                Text("Поиск")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 9)
                    .padding(.top, 9)
                    .padding(.trailing, 17)
                    .foregroundStyle(.black)
            }
            .background(DSColors.searchButton)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        Color(red: 151/255, green: 151/255, blue: 175/255, opacity: 0.3),
                        lineWidth: 1
                    )
            )
        }
    }
}

#Preview {
    SearchButton() {}
        .padding()
}
