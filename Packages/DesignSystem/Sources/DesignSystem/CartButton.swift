//
//  CartButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI

/// Кнопка добавления товара в корзину с отображением цены
public struct CartButton: View {

    private let price: Int
    private let action: () -> Void

    public init(price: Int, action: @escaping () -> Void) {
        self.price = price
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("\(price) ₽")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 40, height: 17)
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(DSColors.plusPinky))
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(DSColors.accentPinky)
            .clipShape(Capsule())
            .frame(width: 84, height: 32)
            .cornerRadius(6)
        }
    }
}

#Preview {
    CartButton(price: 750) {}
        .padding()
}
