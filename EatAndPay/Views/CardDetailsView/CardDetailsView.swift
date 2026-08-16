//
//  CardDetailsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct CardDetailsView: View {

    @Bindable var favoritesService: FavoritesService

    var cartService: CartService
    let productId: String

    @State private var productService = ProductService(networkService: NetworkServicesImpl())
    @State private var isReviewsPresented = false
    @Environment(\.dismiss) private var dismiss

    init(
        productId: String,
        cartService: CartService,
        favoriteServices: FavoritesService
    ) {
        self.productId = productId
        self.cartService = cartService
        self.favoritesService = favoriteServices
    }

    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(
                urlString: productService.productCard?.image ?? "",
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    DSImagePlaceholder()
                }
            )
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
                Text("\(productService.productCard?.price.formatted() ?? "0") ₽")
                    .font(DSTypography.hugeTitle)
                    .frame(width: 297, height: 39, alignment: .leading)
                Spacer()
                Button {
                    Task {
                        await favoritesService.toggleFavorite(for: productId)
                    }
                } label: {
                    Image(favoritesService.isFavorite(productId: productId) ? .isFavorite : .heart)
                        .frame(width: 44, height: 44)
                }
            }
            HStack(spacing: 10) {
                Text(productService.productCard?.name ?? "")
                    .font(DSTypography.cardDetailsTitle)
                Text("\(productService.productCard?.weight.formatted() ?? "") г")
                    .font(DSTypography.cardDetailsTitle)
                    .foregroundStyle(DSColors.textSecondary)
            }
            .frame(width: 294, height: 30, alignment: .leading)
            Button {
                isReviewsPresented = true
            } label: {
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Text(productService.productCard?.rating.formatted() ?? "")
                            .font(DSTypography.cardDetailsTitle)
                        ForEach(0..<Int(ceil(productService.productCard?.rating ?? 5)), id: \.self) { _ in
                            Image(.star)
                                .renderingMode(.template)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    HStack(spacing: 6) {
                        Image(.messages)
                            .renderingMode(.template)
                            .foregroundStyle(Color.primary)
                        Text("\(productService.productCard?.reviews?.count.formatted() ?? " 0")  отзывов")
                            .font(DSTypography.cardDetailsTitle)
                    }
                }
                .frame(width: 351, height: 30, alignment: .leading)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isReviewsPresented) {
                ReviewsView(
                    productService: productService
                )
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(productService.productCard?.description ?? "")
                    .font(DSTypography.descriptionTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            DSButton(
                action: {
                    if let product = productService.productCard {
                        Task {
                            await cartService.add(
                                product: ProductPreviewModel(
                                    id: product.id,
                                    image: product.image,
                                    name: product.name,
                                    weight: product.weight,
                                    price: product.price,
                                    rating: product.rating,
                                    reviewCount: 0,
                                    isFavorite: product.isFavorite,
                                    discount: product.discount
                                )
                            )
                        }
                        dismiss()
                    }
                }
            )
        }
        .padding(.horizontal, 12)
        .task(id: productId) {
            await productService.loadProductDetails(id: productId)
        }
    }
}

#Preview {
    CardDetailsView(
        productId: "",
        cartService:
            CartService(
                cartActor: CartActor(
                    container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                    networkService: NetworkServicesImpl()
                )
            ),
        favoriteServices: FavoritesService(networkServices: NetworkServicesImpl())
    )
}
