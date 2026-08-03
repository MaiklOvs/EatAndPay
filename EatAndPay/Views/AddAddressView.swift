//
//  AddAddressView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.08.2026.
//

import SwiftUI
import DesignSystem

struct AddAddressView: View {

    @Environment(\.dismiss) private var dismiss

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
                Image(.pencil)
                    .padding(.bottom, 26)
                    .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? DSColors.lightGradient : .linearGradient(colors: [.white], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .padding(.horizontal, 12)
        }
    }

    var body: some View {
        HStack {
            Text("Мои адреса")
                .font(DSTypography.hugeTitle)
            Spacer()
            CloseButton(action: { dismiss() })
        }
        .padding(.horizontal, 12)
        .padding(.top, 18)
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                AddressCell(
                    address: "Новая Басманная ул., 35 ст1, 59\n",
                    details: "3 этаж, 4 подъезд, код домофона 15809",
                    isSelected: true
                )
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Новый адрес")
                }
                .padding(.horizontal, 12)
            }
        }
        Spacer()
        DSButton(
            action: {},
            buttonTitle: "Привезти сюда"
        )
        .padding(.horizontal, 12)
    }
}

#Preview {
    AddAddressView()
}
