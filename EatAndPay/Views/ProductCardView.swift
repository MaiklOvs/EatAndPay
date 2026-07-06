//
//  ProductCardView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem

struct ProductCardView: View {

    let product: ProductPreviewModel

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(alignment: .topTrailing) {
                        Button {
                        } label: {
                            Image(.heart)
                                .padding(8)
                        }
                    }
            }
            .frame(width: 174, height: 256)
            .clipShape(RoundedRectangle(cornerRadius: 20))

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
    ProductCardView(product:
                        ProductPreviewModel(
                            id: "",
                            image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                            name: "Огурец в тесте",
                            weight: 80,
                            price: 750,
                            rating: 3.8,
                            reviewCount: 1356,
                            isFavorite: false,
                            discount: 100
                        )
    )
}
