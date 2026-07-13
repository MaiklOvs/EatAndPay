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
    private let action: () -> Void

    public init(count: Int, action: @escaping () -> Void) {
        self.count = count
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 6) {
            Button(action: {}) {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .bold))
            }

            Text(count.formatted())
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 40, height: 17)

            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
            }
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
    CountButton(count: 1) {}
        .padding()
}
