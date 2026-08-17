//
//  ProductCardView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ProductCardView: View {

    let product: ProductPreviewModel

    @Bindable var favoritesService: FavoritesService

    var cartService: CartService

    var body: some View {
        let quantity = cartService.quantity(for: product.id)
        let displayedPrice = quantity > 0 ? product.price * quantity : product.price

        VStack(alignment: .leading) {
            CachedAsyncImage(
                urlString: product.image,
                content: { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, minHeight: 256, maxHeight: 300)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                },
                placeholder: {
                    DSImagePlaceholder()
                }
            )
            .overlay(alignment: .topTrailing) {
                Button {
                    Task {
                        await favoritesService.toggleFavorite(for: product.id)
                    }
                } label: {
                    if favoritesService.isFavorite(productId: product.id) {
                        Image(.isFavorite)
                            .padding(10)
                    } else {
                        Image(.heart)
                            .padding(10)
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
                onDecrement: {
                    Task {
                        await cartService.remove(product: product)
                    }
                },
                onIncrement: {
                    Task {
                        await cartService.add(product: product)
                    }
                },
                isLoading: cartService.loadingItemIds.contains(product.id)
            )
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
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
                    favoritesService: FavoritesService(networkServices: NetworkServicesImpl()), cartService: CartService(
                        cartActor: CartActor(
                        container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                        networkService: NetworkServicesImpl()
                    ))
    )
}
