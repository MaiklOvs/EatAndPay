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
        case white       // белый фон, фиолетовый цвет
        case inputAddress // белый фон, черный текст и рамка
    }

    private let action: () -> Void

    private let buttonTitle: String
    private let style: Style
    private let isLoading: Bool

    func getBackground(style: Style) -> LinearGradient {
        switch style {
        case .accent:
            return DSColors.accentGradient
        case .light:
            return DSColors.lightGradient
        case .white:
            return .linearGradient(colors: [.white], startPoint: .leading, endPoint: .trailing)
        case .inputAddress:
            return .linearGradient(colors: [.white], startPoint: .leading, endPoint: .trailing)
        }
    }

    func getForeground(style: Style) -> Color {
        switch style {
        case .accent:
            return .white
        case .light:
            return .black
        case .white:
            return DSColors.reviewSuccessButtonTitle
        case .inputAddress:
            return .black
        }
    }

    func getBorder(style: Style) -> Color {
        switch style {
        case .accent:
            return .clear
        case .light:
            return .clear
        case .white:
            return .clear
        case .inputAddress:
            return DSColors.addressButtonBorder
        }
    }

    public init(
        action: @escaping () -> Void,
        buttonTitle: String = "В корзину",
        style: Style = .accent,
        isLoading: Bool = false
    ) {
        self.action = action
        self.buttonTitle = buttonTitle
        self.style = style
        self.isLoading = isLoading
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(buttonTitle)
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundStyle(getForeground(style: style))
            .padding(.vertical, 13)
            .background(getBackground(style: style))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(getBorder(style: style), lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    DSButton() {}
        .padding()
}
