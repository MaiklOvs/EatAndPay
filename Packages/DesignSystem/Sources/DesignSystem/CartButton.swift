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
    private let count: Int
    private let onIncrement: () -> Void
    private let onDecrement: () -> Void

    public init(
        price: Int,
        count: Int,
        onDecrement: @escaping () -> Void,
        onIncrement: @escaping () -> Void
    ) {
        self.price = price
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.count = count
    }

    public var body: some View {
        if count > 0 {
            activeButton
        } else {
            defaultButton
        }
    }

    @ViewBuilder
    private var activeButton: some View {
        HStack(spacing: 6) {
            Button(action: onDecrement) { Image(systemName: "minus") }
            Text("\(price) ₽")
                .font(.system(size: 14, weight: .bold))
                .frame(width: 42, height: 17)
            Button(action: onIncrement) { Image(systemName: "plus") }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(DSColors.accentGradient)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private var defaultButton: some View {
        HStack(spacing: 6) {
            Text("\(price) ₽")
            Button(action: onIncrement) { Image(systemName: "plus") }
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(DSColors.accentPinky)
        .clipShape(Capsule())
    }
}

#Preview {
    CartButton(
        price: 750,
        count: 1,
        onDecrement: {},
        onIncrement: {}
    )
    .padding()
}
