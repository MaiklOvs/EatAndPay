//
//  SelectMapAddressButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI

public struct SelectMapAddressButton: View {

    private let onTap: () -> Void

    public init(
        onTap: @escaping () -> Void,
    ) {
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            Text("Указать на карте")
                .font(DSTypography.addressTitle)
                .foregroundStyle(DSColors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 0)
    }
}

#Preview {
    SelectMapAddressButton(onTap: {})
        .padding()
}
