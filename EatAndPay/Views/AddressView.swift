//
//  AddressView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressView: View {

    let address: AddressModel?

    var attributedText: AttributedString {
        var result = AttributedString("\(address?.selectedAddress?.addressLine ?? "Выберите адрес")\n")
        result.font = DSTypography.authorReviewTitle

        var subtitle = AttributedString("Доставка от 15 минут")
        subtitle.font = DSTypography.caption

        result.append(subtitle)
        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(alignment: .top) {
                    Text(attributedText)
                    Image(.chevronRight)
                }
                Spacer()
                Circle()
                    .fill(DSColors.lightGradient)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("А")
                            .font(DSTypography.authorReviewTitle)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .frame(height: 60)
        .background(DSColors.smoky)
        .cornerRadius(12)
    }
}

#Preview {
    AddressView(address: AddressModel(networkService: NetworkServicesImpl()))
}
