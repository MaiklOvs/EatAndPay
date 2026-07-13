//
//  CheckoutButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI

/// Кнопка добавления товара в корзину без отображения цены

public struct CheckoutButton: View {

    private let action: () -> Void
    private let price: Int
    private let count: Int

    public init(
        price: Int,
        count: Int,
        action: @escaping () -> Void) {
            self.action = action
            self.price = price
            self.count = count
        }

    func countString(count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(count) товаров"
        }

        switch lastDigit {
        case 1:
            return "\(count) товар"
        case 2, 3, 4:
            return "\(count) товара"
        default:
            return "\(count) товаров"
        }
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text(price.formatted() + "₽")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.leading, 10)
                        .padding(.top, 7.5)
                    Text(countString(count: count))
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 10)
                        .padding(.bottom, 7.5)
                }
                Text("Оформить")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.trailing, 18)
                    .padding(.bottom, 14.5)
                    .padding(.top, 11.5)
            }
            .foregroundStyle(.white)
            .background(DSColors.accentGradient)
            .cornerRadius(12)
        }
    }
}

#Preview {
    CheckoutButton(price: 100, count: 4) {}
        .padding()
}
