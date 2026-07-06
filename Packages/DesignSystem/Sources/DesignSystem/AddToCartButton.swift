//
//  AddToCartButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI

/// Кнопка добавления товара в корзину без отображения цены

public struct AddToCartButton: View {

    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Text("В корзину")
                    .font(.system(size: 24, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 126)
            .padding(.vertical, 13)
            .background(DSColors.accentGradient)
            .cornerRadius(12)
        }
    }
}

#Preview {
    AddToCartButton() {}
        .padding()
}
