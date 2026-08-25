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

    private func reviewCountString(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(count) отзывов"
        }

        switch lastDigit {
        case 1:
            return "\(count) отзыв"
        case 2, 3, 4:
            return "\(count) отзыва"
        default:
            return "\(count) отзывов"
        }
    }

    @ViewBuilder
    private func contentView(product: ProductCardModel) -> some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(
                urlString: product.image,
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
                Text("\(product.price.formatted()) ₽")
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
                Text(product.name)
                    .font(DSTypography.cardDetailsTitle)
                Text("\(product.weight.formatted()) г")
                    .font(DSTypography.cardDetailsTitle)
                    .foregroundStyle(DSColors.textSecondary)
            }
            .frame(height: 30)
            Button {
                isReviewsPresented = true
            } label: {
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Text(product.rating.ratingString)
                            .font(DSTypography.bodyLarge)
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
                        Text(reviewCountString(for: product.reviews?.count ?? 0))
                            .font(DSTypography.bodyLarge)
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
                Text(product.description)
                    .font(DSTypography.descriptionTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            DSButton(
                action: {
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
                        dismiss()
                    }
                },
                isLoading: cartService.loadingItemIds.contains(productId)
            )
        }
        .padding(.horizontal, 12)
    }

    var body: some View {
        ZStack {
            if let product = productService.productCard {
                contentView(product: product)
            } else if productService.isLoadingCartDetail {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.5)
            }
        }
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
