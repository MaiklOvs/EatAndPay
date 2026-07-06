//
//  CloseButton.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI

final class CloseButton: View {
    
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text("Закрыть")
        }
        .frame(width: 24, height: 24)
    }
}

#Preview {
    CloseButton() {}
        .padding()
}

