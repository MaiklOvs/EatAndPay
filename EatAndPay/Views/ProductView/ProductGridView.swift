//
//  ProductGridView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 17.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ProductGridView: View {

    let productPreviewModel: [ProductPreviewModel]
    let title: String

    var cartService: CartService

    @Bindable var favoritesService: FavoritesService
    @State private var selectedProduct: ProductPreviewModel?

    var body: some View {
        ScrollView {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(DSTypography.hugeTitle)
                .tracking(-0.165)
                .lineSpacing(7)
                .padding(.top, 20)
                .padding(.bottom, 8)
                .padding(.leading, 12)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 16
            ) {
                ForEach(productPreviewModel) { data in
                    ProductCardView(
                        product: data,
                        favoritesService: favoritesService,
                        cartService: cartService
                    )
                    .frame(width: 205)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        selectedProduct = data
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .animation(.easeOut(duration: 0.2), value: productPreviewModel)
        }
        .sheet(item: $selectedProduct) { product in
            CardDetailsView(
                productId: product.id,
                cartService: cartService,
                favoriteServices: favoritesService
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ProductGridView(
        productPreviewModel: [
            ProductPreviewModel(
                id: "1",
                image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                name: "Огурец в тесте",
                weight: 80,
                price: 750,
                rating: 3.8,
                reviewCount: 1356,
                isFavorite: false,
                discount: 100
            ),
            ProductPreviewModel(
                id: "2",
                image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                name: "Огурец в тесте",
                weight: 80,
                price: 750,
                rating: 3.8,
                reviewCount: 1356,
                isFavorite: false,
                discount: 100
            )
        ],
        title: "Выпечка",
        cartService:
            CartService(
                cartActor: CartActor(
                    container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                    networkService: NetworkServicesImpl()
                )
            ),
        favoritesService: FavoritesService(networkServices: NetworkServicesImpl())
    )
}
