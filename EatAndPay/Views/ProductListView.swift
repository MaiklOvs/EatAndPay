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

    @Bindable var cartViewModel: CartViewModel
    @State var searchViewModel: SearchViewModel
    @State private var isCartPresented = false
    @State private var isSearchPresented = false

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
        ProductGridView(
            productPreviewModel: catalogModel.products.data,
            title: name,
            onFavoriteToggle: { productId in
                Task {
                    await catalogModel.toggleFavorite(for: productId)
                }
            },
            cartViewModel: cartViewModel
        )
        .overlay(alignment: .bottom) {
            HStack {
                SearchButton(action: {
                    isSearchPresented = true
                })
                Spacer()
                checkoutButtonView
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .task {
            await catalogModel.loadProductsList(query: Operations.get_sol_products.Input.Query(category: category))
        }
        .sheet(isPresented: $isCartPresented) {
            CartView(cartViewModel: cartViewModel)
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView(
                onFavoriteToggle: { productId in
                    Task {
                        await catalogModel.toggleFavorite(for: productId)
                    }
                    if let index = searchViewModel.allProducts.firstIndex(where: { $0.id == productId }) {
                        searchViewModel.allProducts[index].isFavorite.toggle()
                    }
                },
                searchViewModel: searchViewModel,
                cartViewModel: cartViewModel
            )
        }
    }
}

#Preview {
    ProductListView(
        catalogModel: CatalogModel(networkService: NetworkServicesImpl()),
        name: "Выпечка",
        category: "bakery",
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl()),
        searchViewModel: SearchViewModel(allProducts: [])
    )
}
