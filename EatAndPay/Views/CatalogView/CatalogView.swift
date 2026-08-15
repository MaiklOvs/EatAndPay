//
//  CatalogView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import SwiftData
import DesignSystem

struct CatalogView: View {

    @Environment(\.modelContext) private var context

    @State private var catalogModel: CatalogModel
    var cartService: CartService
    @State private var searchViewModel = SearchViewModel(allProducts: [])
    @State private var addressModel = AddressModel(networkService: NetworkServicesImpl())
    @State private var path = NavigationPath()
    @State private var isCartPresented = false
    @State private var isSearchPresented = false
    @State private var isAddNewAddressPresented = false

    init(catalogModel: CatalogModel, cartService: CartService) {
        self._catalogModel = State(initialValue: catalogModel)
        self.cartService = cartService
    }

    @ViewBuilder
    private func checkoutButtonView(isPresented: Binding<Bool>) -> some View {
        if let cart = cartService.cart, !cart.items.isEmpty {
            CheckoutButton(
                price: cartService.totalPrice(),
                count: cartService.totalCount()
            ) {
                isPresented.wrappedValue = true
            }
            .padding(.bottom, 12)
            .frame(height: 50)
        }
    }

    @ViewBuilder
    private func searchButtonView(isPresented: Binding<Bool>) -> some View {
        SearchButton(action: {
            isPresented.wrappedValue = true
        })
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                Button {
                    isAddNewAddressPresented = true
                } label: {
                    AddressView(address: addressModel)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 15)
                .buttonStyle(.plain)
                TextTabBar(
                    selectedIndex: Binding(
                        get: { catalogModel.selectedTab.rawValue },
                        set: { catalogModel.selectedTab = CatalogModel.Tab(rawValue: $0) ?? .forYou }
                    ),
                    tabs: ["Для тебя", "Каталог", "Скидки", "Избранное"]
                )

                .padding(.top, 0)

                switch catalogModel.selectedTab {
                case .forYou:
                    Text("Для тебя")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .catalog:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("От Даркстора")
                                .font(DSTypography.hugeTitle)
                                .tracking(-0.165)
                                .lineSpacing(7)
                                .padding(.top, 20)
                                .padding(.bottom, 8)

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 2),
                                    GridItem(.flexible(), spacing: 2),
                                    GridItem(.flexible(), spacing: 2)
                                ],
                                spacing: 2
                            ) {
                                ForEach(catalogModel.catalogService.categories) { category in
                                    Button {
                                        path.append(category)
                                    } label: {
                                        CatalogCardsView(catalogCardModel: category)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                case .discounts:
                    Text("Скидки")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    ProductGridView(
                        productPreviewModel: catalogModel.catalogService.products.data.filter { catalogModel.catalogService.favoritesService.isFavorite(productId: $0.id) },
                        title: "Избранное",
                        cartService: cartService,
                        favoritesService: catalogModel.catalogService.favoritesService
                    )
                    .task(id: catalogModel.selectedTab) {
                        if catalogModel.selectedTab == .favorites {
                            await catalogModel.catalogService.loadAllProducts()
                        }
                    }
                }
            }
            .onChange(of: catalogModel.catalogService.products.data) { _, newValue in
                searchViewModel.allProducts = newValue
            }
            .overlay(alignment: .bottom) {
                HStack {
                    searchButtonView(isPresented: $isSearchPresented)
                        .frame(height: 50)
                    Spacer()
                    checkoutButtonView(isPresented: $isCartPresented)
                        .frame(height: 50)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .navigationTitle("")
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
                    cartService: cartService
                )
            }
            .sheet(isPresented: $isAddNewAddressPresented) {
                AddressListView(addressModel: addressModel)
            }
            .navigationDestination(for: CatalogCard.self) { category in
                ProductListView(
                    catalogModel: catalogModel,
                    addressModel: addressModel,
                    name: category.name,
                    category: category.id,
                    cartService: cartService,
                    searchViewModel: searchViewModel
                )
            }
            .task {
                await catalogModel.catalogService.loadCategories()
                await catalogModel.catalogService.loadProductsList()
                await cartService.loadCart()
                await addressModel.loadAddress()
                searchViewModel.allProducts = catalogModel.catalogService.products.data
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
    let cartService = CartService(
        cartActor: CartActor(
            container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
            networkService: networkService
        )
    )

    CatalogView(
        catalogModel: catalogModel,
        cartService: cartService
    )
        .modelContainer(for: [PersistedCart.self, PersistedCartItem.self])
}
