//
//  CloseButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI

/// Кнопка закрытия

public struct CloseButton: View {

    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 16, height: 2)
                    .rotationEffect(.degrees(45))
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 16, height: 2)
                    .rotationEffect(.degrees(-45))
            }
            .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    CloseButton() {}
        .padding()
}
