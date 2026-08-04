//
//  AddressCellView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 04.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressCell: View {
    let address: String
    let details: String
    let isSelected: Bool

    var attributedText: AttributedString {
        var result = AttributedString(address)
        result.font = DSTypography.addressTitle
        var subtitle = AttributedString(details)
        subtitle.font = DSTypography.caption
        subtitle.foregroundColor = DSColors.textSecondary

        result.append(subtitle)
        return result
    }

    var body: some View {
        HStack {
            Text(attributedText)
                .padding(.horizontal, 12)
            Spacer()
            Button {
            } label: {
                Image(.pencil)
                    .padding(.bottom, 26)
                    .padding(.trailing, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? DSColors.lightGradient : .linearGradient(colors: [.white], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(12)
        .padding(.horizontal, 12)
    }
}

#Preview {
    AddressCell(
        address: "Новая Басманная ул., 35 ст1, 59\n",
        details: "3 этаж, 4 подъезд, код домофона 15809",
        isSelected: true
    )
}
