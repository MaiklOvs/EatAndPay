//
//  CardDetailsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI
import DesignSystem

struct CardDetailsView: View {

    let product: ProductCardModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 375, height: 440)
            .overlay {
                CloseButton(action: { dismiss() } )
                    .padding(.leading, 331)
                    .padding(.trailing, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 398)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 10) {
                Text(product.price.formatted() + " ₽")
                    .font(DSTypography.hugeTitle)
                    .frame(width: 297, height: 39, alignment: .leading)
                Button {
                } label: {
                    Image(.heart)
                        .frame(width: 44, height: 44)
                }
            }
            HStack(spacing: 10) {
                Text(product.name)
                    .font(DSTypography.cardDetailsTitle)
                Text(product.weight.formatted() + "г")
                    .font(DSTypography.cardDetailsTitle)
                    .foregroundStyle(DSColors.textSecondary)
            }
            .frame(width: 294, height: 30, alignment: .leading)
            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Text(product.rating.formatted())
                        .font(DSTypography.cardDetailsTitle)
                    ForEach(0..<Int(ceil(product.rating)), id: \.self) { _ in
                        Image(.star)
                            .renderingMode(.template)
                            .foregroundStyle(Color.primary)
                    }
                }
                HStack(spacing: 6) {
                    Image(.messages)
                        .renderingMode(.template)
                        .foregroundStyle(Color.primary)
                    Text(product.reviews.count.formatted() + " отзывов")
                        .font(DSTypography.cardDetailsTitle)
                }
            }
            .frame(width: 351, height: 30, alignment: .leading)

            Text(product.description)
                .font(DSTypography.descriptionTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            AddToCartButton(
                action: {}
            )
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    CardDetailsView(product:
                        ProductCardModel(
                            id: "",
                            image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                            name: "Огурец в тесте",
                            weight: 80,
                            price: 750,
                            rating: 3.8,
                            description: "Изысканная простота в каждой детали. Наш фирменный бутерброд — это воплощение классического сочетания отборных ингредиентов, которое придётся по вкусу даже самым искушённым гурманам.",
                            isFavorite: false,
                            discount: 100,
                            reviews: []
                        )
    )
}
