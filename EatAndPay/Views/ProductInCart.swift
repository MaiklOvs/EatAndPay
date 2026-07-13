//
//  ProductInCart.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem

struct ProductInCart: View {

    let product: ProductCardModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.image)) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text("900 ₽")
                HStack {
                    Text("Огурец в тесте")
                    Text("100 г")
                        .foregroundStyle(DSColors.textSecondary)
                }
                CountButton(count: 1, action: {})
            }
            .padding(.bottom, 21)
        }
    }
}

#Preview {
    ProductInCart(product:
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
