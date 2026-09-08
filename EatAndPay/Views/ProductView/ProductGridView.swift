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
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        selectedProduct = data
                    }
                }
            }
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
        productPreviewModel: [],
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
