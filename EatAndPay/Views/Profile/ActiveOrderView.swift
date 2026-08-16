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

    let productPreviewModel: [ProductPreviewModel]
    let favoriteSetvice: FavoritesService
    let cartService: CartService

    var attributedText: AttributedString {
        var result = AttributedString("Доставим через 12 минут\n")
        result.font = DSTypography.authorReviewTitle

        var subtitle = AttributedString("Новая Басманная ул., 35 ст1, 59")
        subtitle.font = DSTypography.caption

        result.append(subtitle)
        return result
    }

    var body: some View {
        VStack {
            HStack {
                Text(attributedText)
                    .padding(.leading, 12)
                Spacer()
                Image(.chevronRight)
                    .padding(.trailing, 12)
            }
            .frame(width: 351, height: 41)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(productPreviewModel) { product in
                        ProductCardView(
                            product: product,
                            favoritesService: favoriteSetvice,
                            cartService: cartService
                        )
                    }
                }
            }
            .padding(.leading, 12)
        }
        .background(DSColors.lightGradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ActiveOrderView(
        productPreviewModel: [ProductPreviewModel(
            id: "",
            image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
            name: "Огурец в тесте",
            weight: 80,
            price: 750,
            rating: 3.8,
            reviewCount: 1356,
            isFavorite: false,
            discount: 100
        )],
        favoriteSetvice: FavoritesService(networkServices: NetworkServicesImpl()),
        cartService: CartService(
            cartActor: CartActor(
            container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
            networkService: NetworkServicesImpl()
            )
        )
    )
}
