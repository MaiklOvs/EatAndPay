//
//  ProductListView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 06.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ProductListView: View {

    let catalogModel: CatalogModel
    let addressModel: AddressModel
    let name: String
    let category: String

    var cartService: CartService
    @State var searchViewModel: SearchViewModel
    @State private var isCartPresented = false
    @State private var isSearchPresented = false

    @ViewBuilder
    private var checkoutButtonView: some View {
        if let cart = cartService.cart, !cart.items.isEmpty {
            CheckoutButton(
                price: cartService.totalPrice(),
                count: cartService.totalCount()
            ) {
                isCartPresented = true
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var body: some View {
        ProductGridView(
            productPreviewModel: catalogModel.catalogService.products.data,
            title: name,
            cartService: cartService,
            favoritesService: catalogModel.catalogService.favoritesService
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
        .overlay {
            if catalogModel.catalogService.isLoadingProducts && catalogModel.catalogService.products.data.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.5)
            }
        }
        .task {
            await catalogModel.catalogService.loadProductsList(query: Operations.get_sol_products.Input.Query(category: category))
        }
        .sheet(isPresented: $isCartPresented) {
            CartView(
                addressModel: addressModel,
                cartService: cartService
            )
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView(
                searchViewModel: searchViewModel,
                favoritesService: catalogModel.catalogService.favoritesService,
                cartService: cartService,
                isLoading: catalogModel.catalogService.isLoadingProducts
            )
            .task {
                await catalogModel.catalogService.loadAllProducts()
            }
        }
    }
}

#Preview {
    let networkService = NetworkServicesImpl()
    let favoritesService = FavoritesService(networkServices: networkService)
    let catalogService = CatalogService(
        networkService: networkService,
        favoritesService: favoritesService
    )
    let catalogModel = CatalogModel(catalogService: catalogService)

    ProductListView(
        catalogModel: catalogModel,
        addressModel: AddressModel(networkService: networkService),
        name: "Выпечка",
        category: "bakery",
        cartService:
            CartService(
                cartActor: CartActor(
                    container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                    networkService: networkService
                )
            ),
        searchViewModel: SearchViewModel(allProducts: [])
    )
}
