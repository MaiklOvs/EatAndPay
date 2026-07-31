//
//  DSImagePlaceholder.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 31.07.2026.
//

import SwiftUI

// DSImagePlaceholder - плейсхолдер заглушка для картинок в КТ, когда не получилось получить с бека

public struct DSImagePlaceholder: View {

    public let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = 20) {
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(DSColors.cardBackground)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(DSColors.textSecondary)
            }
    }
}

#Preview {
    DSImagePlaceholder()
}
