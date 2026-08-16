//
//  SearchView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 16.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct SearchView: View {

    @Bindable var searchViewModel: SearchViewModel
    @Bindable var favoritesService: FavoritesService


    var cartService: CartService
    var isLoading: Bool = false

    @State private var isSearchBarFocused = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(.backButton)
                }
                .padding(.leading, 12)
                .padding(.top, 12)
                Spacer()
            }
            if isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack {
                        if searchViewModel.searchText.isEmpty && isSearchBarFocused {
                            ForEach(searchViewModel.searchHistory, id: \.self) { query in
                                Button {
                                    searchViewModel.searchText = query
                                } label: {
                                    Text(query)
                                        .font(DSTypography.searchTitle)
                                        .foregroundStyle(.black)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 12)
                                }
                            }
                        }
                        if !searchViewModel.searchText.isEmpty && isSearchBarFocused {
                            ForEach(searchViewModel.suggestions, id: \.self) { suggestion in
                                Button {
                                    searchViewModel.searchText = suggestion
                                } label: {
                                    Text(suggestion)
                                        .font(DSTypography.searchTitle)
                                        .foregroundStyle(.black)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 12)
                                }
                            }
                        }
                        if !searchViewModel.searchText.isEmpty {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 2),
                                    GridItem(.flexible(), spacing: 2)
                                ],
                                spacing: 2
                            ) {
                                ForEach(searchViewModel.results) { result in
                                    ProductCardView(
                                        product: result,
                                        favoritesService: favoritesService,
                                        cartService: cartService
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
            SearchBar(
                searchText: $searchViewModel.searchText,
                isFocused: $isSearchBarFocused,
                action: {
                searchViewModel.addToHistory(searchViewModel.searchText)

            })
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
    }
}

#Preview {
    SearchView(
        searchViewModel: SearchViewModel(allProducts: [
            ProductPreviewModel(
                id: "",
                image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                name: "Огурец в тесте",
                weight: 80,
                price: 750,
                rating: 3.8,
                reviewCount: 1356,
                isFavorite: false,
                discount: 100
            )
        ]),
        favoritesService: FavoritesService(networkServices: NetworkServicesImpl()),
        cartService:
            CartService(
                cartActor: CartActor(
                    container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                    networkService: NetworkServicesImpl()
                )
            ),
        isLoading: true
    )
}
