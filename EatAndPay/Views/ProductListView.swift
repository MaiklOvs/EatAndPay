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
    @State private var productCardViewModel = ProductCardViewModel(networkService: NetworkServicesImpl())
    @State private var isCartPresented = false

    @ViewBuilder
    private var checkoutButtonView: some View {
        if let cart = cartViewModel.cart, !cart.items.isEmpty {
            CheckoutButton(
                price: cartViewModel.totalPrice(),
                count: cartViewModel.totalCount()
            ) {
                isCartPresented = true
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

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
        .overlay(alignment: .bottom) {
            HStack {
                SearchButton(action: {})
                Spacer()
                checkoutButtonView
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .task {
            await catalogModel.loadProductsList(query: Operations.get_sol_products.Input.Query(category: category))
        }
        .sheet(item: $selectedProduct) { product in
            CardDetailsView(viewModel: productCardViewModel, cartViewModel: cartViewModel)
                .task(id: product.id) {
                    await productCardViewModel.loadProductDetails(id: product.id)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isCartPresented) {
            CartView(cartViewModel: cartViewModel)
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
