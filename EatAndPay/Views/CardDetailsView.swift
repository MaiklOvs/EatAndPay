//
//  CardDetailsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI
import DesignSystem

struct CardDetailsView: View {

    @State private var viewModel = ProductCardViewModel(networkService: NetworkServicesImpl())
    @Bindable var cartViewModel: CartViewModel
    let productId: String
    let onFavoriteToggle: () -> Void
    @State private var isFavorite = false
    @Environment(\.dismiss) private var dismiss

    init(
        productId: String,
        cartViewModel: CartViewModel,
        onFavoriteToggle: @escaping () -> Void
    ) {
        self.productId = productId
        self.cartViewModel = cartViewModel
        self.onFavoriteToggle = onFavoriteToggle
    }

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: viewModel.productCard?.image ?? "")) { image in
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
                Text("\(viewModel.productCard?.price.formatted() ?? "0") ₽")
                    .font(DSTypography.hugeTitle)
                    .frame(width: 297, height: 39, alignment: .leading)
                Spacer()
                Button {
                    isFavorite.toggle()
                    onFavoriteToggle()
                } label: {
                    Image(isFavorite ? .isFavorite : .heart)
                        .frame(width: 44, height: 44)
                }
            }
            HStack(spacing: 10) {
                Text(viewModel.productCard?.name ?? "")
                    .font(DSTypography.cardDetailsTitle)
                Text("\(viewModel.productCard?.weight.formatted() ?? "") г")
                    .font(DSTypography.cardDetailsTitle)
                    .foregroundStyle(DSColors.textSecondary)
            }
            .frame(width: 294, height: 30, alignment: .leading)
            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Text(viewModel.productCard?.rating.formatted() ?? "")
                        .font(DSTypography.cardDetailsTitle)
                    ForEach(0..<Int(ceil(viewModel.productCard?.rating ?? 5)), id: \.self) { _ in
                        Image(.star)
                            .renderingMode(.template)
                            .foregroundStyle(Color.primary)
                    }
                }
                HStack(spacing: 6) {
                    Image(.messages)
                        .renderingMode(.template)
                        .foregroundStyle(Color.primary)
                    Text("\(viewModel.productCard?.reviews?.count.formatted() ?? " 0")  отзывов")
                        .font(DSTypography.cardDetailsTitle)
                }
            }
            .frame(width: 351, height: 30, alignment: .leading)

            Text(viewModel.productCard?.description ?? "")
                .font(DSTypography.descriptionTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            AddToCartButton(
                action: {
                    if let product = viewModel.productCard {
                        cartViewModel.add(
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
                }
            )
        }
        .padding(.horizontal, 12)
        .task(id: productId) {
            await viewModel.loadProductDetails(id: productId)
            isFavorite = viewModel.productCard?.isFavorite ?? false
        }
    }
}

#Preview {
    CardDetailsView(
        productId: "",
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl()),
        onFavoriteToggle: {  }
    )
}
