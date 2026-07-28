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

    private let buttonTitle: String

    public init(action: @escaping () -> Void, buttonTitle: String = "В корзину") {
        self.action = action
        self.buttonTitle = buttonTitle
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Text(buttonTitle)
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
