//
//  CartView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem

struct CartView: View {

    let product: ProductCardModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Корзина")
                    .font(DSTypography.hugeTitle)

                Text("4")
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)

                CloseButton(action: { dismiss() } )
                    .padding(.leading, 188)
            }

            HStack {
                Text("15 минут · ")
                Text("4 товара")
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ProductInCart(product: product)
                    ProductInCart(product: product)
                    ProductInCart(product: product)
                    ProductInCart(product: product)
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    CartView(product:
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
