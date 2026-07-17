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
    @Bindable var cartViewModel: CartViewModel

    var body: some View {
        let quantity = cartViewModel.quantity(for: product.id)
        let displayedPrice = quantity > 0 ? product.price * quantity : product.price

        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.image?.resizable()
                    .aspectRatio(174.0 / 200.0, contentMode: .fill)
            }
            .frame(width: 174, height: 256)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                } label: {
                    if product.isFavorite {
                        Image(.isFavorite)
                            .padding(10)
                    } else {
                        Image(.heart)
                            .padding(8)
                    }
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
                price: displayedPrice,
                count: quantity,
                onDecrement: { cartViewModel.remove(product: product) },
                onIncrement: { cartViewModel.add(product: product) }
            )
        }
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
                        ),
                    cartViewModel: CartViewModel(networkService: NetworkServicesImpl())
    )
}
