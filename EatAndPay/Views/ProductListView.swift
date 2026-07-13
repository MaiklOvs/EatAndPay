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
    @Bindable var cartViewModel: CartViewModel
    let name: String
    let category: String
    @State private var selectedProduct: ProductPreviewModel?

    var body: some View {
        ScrollView {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(DSTypography.hugeTitle)
                .tracking(-0.165)
                .lineSpacing(7)
                .padding(.top, 20)
                .padding(.bottom, 8)
                .padding(.leading, 12)
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
                                        ),
                                    cartViewModel: cartViewModel
                    )
                    .onTapGesture {
                        selectedProduct = data
                    }
                }
            }
            .padding(10)
        }
        .task {
            await catalogModel.loadProductsList(query: Operations.get_sol_products.Input.Query(category: category))
        }
        .sheet(item: $selectedProduct) { product in
            CardDetailsView(product:
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
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ProductListView(
        catalogModel: CatalogModel(networkService: NetworkServicesImpl()),
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl()), name: "Выпечка",
        category: "bakery"
    )
}
