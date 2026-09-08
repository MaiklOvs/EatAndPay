//
//  CountButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI

/// Кнопка добавления товара в корзину с отображением цены
public struct CountButton: View {

    private let count: Int
    private let onIncrement: () -> Void
    private let onDecrement: () -> Void
    private var isLoading: Bool

    public init(
        count: Int,
        onDecrement: @escaping () -> Void,
        onIncrement: @escaping () -> Void,
        isLoading: Bool = false
    ) {
        self.count = count
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.isLoading = isLoading
    }

    public var body: some View {
        HStack(spacing: 6) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: 16, height: 17)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
            } else {
                Text(count.formatted())
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 40, height: 17)
            }

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: 16, height: 17)
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(DSColors.smoky)
        .clipShape(Capsule())
        .frame(width: 106, height: 32)
    }
}

#Preview {
    CountButton(
        count: 1,
        onDecrement: {},
        onIncrement: {},
        isLoading: true
    )
        .padding()
}
