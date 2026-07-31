//
//  ProductGridView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 17.07.2026.
//

import SwiftUI
import DesignSystem

struct ProductGridView: View {

    let productPreviewModel: [ProductPreviewModel]
    let title: String

    let onFavoriteToggle: (String) -> Void
    @Bindable var cartViewModel: CartViewModel
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
                    GridItem(.fixed(174), spacing: 10),
                    GridItem(.fixed(174), spacing: 10)
                ],
                spacing: 16
            ) {
                ForEach(productPreviewModel) { data in
                    ProductCardView(
                        product: data,
                        onFavoriteToggle: {
                            onFavoriteToggle(data.id)
                        },
                        cartViewModel: cartViewModel
                    )
//                    .frame(height: 355)
//                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedProduct = data
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .sheet(item: $selectedProduct) { product in
            CardDetailsView(
                productId: product.id,
                cartViewModel: cartViewModel,
                onFavoriteToggle: { onFavoriteToggle(product.id) }
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
        onFavoriteToggle: { _ in },
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl())
    )
}
