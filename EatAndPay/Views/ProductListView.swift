//
//  ProductListView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI
import DesignSystem

struct ProductListView: View {

    let catalogModel: CatalogModel
    let name: String
    let category: String

    var body: some View {
        ScrollView {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(DSTypography.hugeTitle)
                .tracking(-0.165)
                .lineSpacing(7)
                .padding(.top, 20)
                .padding(.bottom, 8)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 3),
                    GridItem(.flexible(), spacing: 3)
                ],
                spacing: 16
            ) {
                ForEach(catalogModel.products.data) { data in
                    ProductCardView(product:
                                        ProductPreviewModel(
                                            id: data.id,
                                            image: data.image,
                                            name: data.name,
                                            weight: data.weight,
                                            price: data.price,
                                            rating: data.rating,
                                            reviewCount: data.reviewCount,
                                            isFavorite: data.isFavorite,
                                            discount: data.discount
                                        )
                    )
                }
            }
            .padding(10)
        }
        .task {
            await catalogModel.loadProductsList(query: Operations.get_sol_products.Input.Query(category: category))
        }
    }
}

#Preview {
    ProductListView(
        catalogModel: CatalogModel(networkService: NetworkServicesImpl()),
        name: "Выпечка",
        category: "bakery"
    )
}
