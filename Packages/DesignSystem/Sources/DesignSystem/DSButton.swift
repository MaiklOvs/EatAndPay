//
//  AddToCartButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI

/// Универсальная кнопка с разными стилями, используется
/// для добавления товара в корзину и добавления отзыва

public struct DSButton: View {

    public enum Style {
        case accent      // фиолетовый градиент, белый текст
        case light       // светлый градиент, тёмный текст
    }

    private let action: () -> Void

    private let buttonTitle: String
    private let style: Style

    func getBackground(style: Style) -> LinearGradient {
        switch style {
        case .accent:
            return DSColors.accentGradient
        case .light:
            return DSColors.lightGradient
        }
    }

    func getForeground(style: Style) -> Color {
        switch style {
        case .accent:
            return .white
        case .light:
            return .black
        }
    }

    public init(
        action: @escaping () -> Void,
        buttonTitle: String = "В корзину",
        style: Style = .accent
    ) {
        self.action = action
        self.buttonTitle = buttonTitle
        self.style = style
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Text(buttonTitle)
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundStyle(getForeground(style: style))
            .padding(.vertical, 13)
            .background(getBackground(style: style))
            .cornerRadius(12)
        }
    }
}

#Preview {
    DSButton() {}
        .padding()
}
