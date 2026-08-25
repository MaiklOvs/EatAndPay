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
        onIncrement: @escaping () -> Void,
    ) {
        self.price = price
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.count = count
    }

    public var body: some View {
        Group {
            if count > 0 {
                activeButton
            } else {
                defaultButton
            }
        }
        .animation(.easeInOut(duration: 0.2), value: count)
    }

    @ViewBuilder
    private var activeButton: some View {
        HStack(spacing: 6) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 16, height: 17)
            }
            .frame(width: 16, height: 17)
            Text("\(price) ₽")
                .font(.system(size: 14, weight: .bold))
                .frame(minWidth: 34, maxHeight: 17)
                .contentTransition(.numericText())
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 16, height: 17)
            }
            .frame(width: 16, height: 17)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .frame(height: 32)
        .background(DSColors.accentGradient)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay {
            HStack {
                Color.clear
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDecrement)
                Spacer()
                Color.clear
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onIncrement)
            }
        }
    }

    @ViewBuilder
    private var defaultButton: some View {
        HStack(spacing: 6) {
            Button(action: onIncrement) {
                Text("\(price) ₽")
                Image(systemName: "plus")
            }
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(DSColors.accentPinky)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .frame(height: 32)
    }
}

#Preview {
    CartButton(
        price: 150,
        count: 1,
        onDecrement: {},
        onIncrement: {}
    )
    .padding()
}
