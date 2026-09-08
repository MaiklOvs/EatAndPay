//
//  ActiveOrderView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 16.08.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ActiveOrderView: View {

    let orders: [OrderItemModel]
    let addressLine: String

    var attributedText: AttributedString {
        var result = AttributedString("Доставим через 12 минут\n")
        result.font = DSTypography.descriptionTitle

        var subtitle = AttributedString("\(addressLine)")
        subtitle.font = DSTypography.caption

        result.append(subtitle)
        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(attributedText)
                    .padding(.leading, 12)
                    .padding(.top, 12)
                Spacer()
                Image(.chevronRight)
                    .padding(.trailing, 12)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(orders) { order in
                        CompactProductCardView(
                            product: order
                        )
                    }
                }
            }
            .padding(.leading, 12)
            .frame(height: 240)
        }
        .background(DSColors.lightGradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ActiveOrderView(
        orders: [
            OrderItemModel(
                id: "",
                image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                name: "Огурец в тесте",
                weight: 100,
                price: 1000,
                quantity: 12
            )
        ], addressLine: ""
    )
}
