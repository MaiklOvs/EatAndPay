//
//  CatalogView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem

struct CatalogView: View {

    @State private var catalogModel = CatalogModel(networkService: NetworkServicesImpl())
    @State private var cartViewModel = CartViewModel(networkService: NetworkServicesImpl())
    @State private var path = NavigationPath()
    @State private var isCartPresented = false

    @ViewBuilder
    private func checkoutButtonView(isPresented: Binding<Bool>) -> some View {
        if let cart = cartViewModel.cart, !cart.items.isEmpty {
            CheckoutButton(
                price: cartViewModel.totalPrice(),
                count: cartViewModel.totalCount()
            ) {
                isPresented.wrappedValue = true
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
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
                                ForEach(catalogModel.categories) { category in
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
                    .task {
                        await catalogModel.loadCategories()
                        await cartViewModel.loadCart()
                    }
                case .discounts:
                    Text("Скидки")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Избранное")
                                .font(DSTypography.hugeTitle)
                                .tracking(-0.165)
                                .lineSpacing(7)
                                .padding(.top, 20)
                                .padding(.bottom, 8)

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 2),
                                    GridItem(.flexible(), spacing: 2),
                                ],
                                spacing: 2
                            ) {
                                ForEach(catalogModel.products.data) { item in
                                    if item.isFavorite {
                                        ProductCardView(
                                            product: ProductPreviewModel(
                                                id: item.id,
                                                image: item.image,
                                                name: item.name,
                                                weight: item.weight,
                                                price: item.price,
                                                rating: item.rating,
                                                reviewCount: item.reviewCount,
                                                isFavorite: item.isFavorite,
                                                discount: item.discount
                                            ),
                                            cartViewModel: cartViewModel
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                HStack {
                    SearchButton(action: {})
                    Spacer()
                    checkoutButtonView(isPresented: $isCartPresented)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .navigationTitle("")
            .sheet(isPresented: $isCartPresented) {
                CartView(cartViewModel: cartViewModel)
            }
            .navigationDestination(for: CatalogCard.self) { category in
                ProductListView(
                    catalogModel: catalogModel,
                    cartViewModel: cartViewModel,
                    name: category.name,
                    category: category.id
                )
            }
        }
    }
}

#Preview {
    CatalogView()
}
