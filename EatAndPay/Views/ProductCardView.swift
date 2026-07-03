//
//  ProductCardView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem

struct ProductCardView: View {

    let product: ProductPreview

    var body: some View {
        VStack(alignment: .leading) {
            Image(._2Deaa666Ff205425Bdebaf46C80E8Efc7C129Eef)
                .resizable()
                .frame(width: 174, height: 256)
                .cornerRadius(20)
                .overlay(alignment: .topTrailing) {
                    Button {
                    } label: {
                        Image(.heart)
                            .padding(8)
                    }
                }

            HStack(spacing: 6) {
                Text(product.name)
                    .font(DSTypography.cardTitle)
                Text(product.weight.formatted() + "г")
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary)
            }
            HStack {
                Image(.star)
                    .renderingMode(.template)
                    .foregroundStyle(Color.primary)
                Text(product.rating.formatted())
                    .font(DSTypography.caption)
                Image(.messages)
                    .renderingMode(.template)
                    .foregroundStyle(Color.primary)
                Text(product.reviewCount.formatted())
                    .font(DSTypography.caption)
            }
            CartButton(
                price: product.price,
                action: {}
            )
        }
        .frame(width: 174, height: 355)
    }
}

#Preview {
    ProductCardView(product: ProductPreview(id: "", image: "", name: "Огурец в тесте", weight: 80, price: 750, rating: 3.8, reviewCount: 1356, isFavorite: false, discount: 100))
}
