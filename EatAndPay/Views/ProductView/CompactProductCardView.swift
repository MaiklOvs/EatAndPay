//
//  CompactProductCardView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct CompactProductCardView: View {

    let product: OrderItemModel

    var body: some View {

        VStack(alignment: .leading) {
            CachedAsyncImage(
                urlString: product.image,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 132, height: 174)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                },
                placeholder: {
                    DSImagePlaceholder()
                }
            )
            HStack(spacing: 6) {
                Text(product.name)
                    .font(DSTypography.cardTitle)
                Text(product.weight.formatted() + "г")
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary)
            }
        }
    }
}

#Preview {
    CompactProductCardView(
        product: OrderItemModel(
            id: "",
            image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
            name: "Огурец в тесте",
            weight: 100,
            price: 1000,
            quantity: 12
        )
    )
}
