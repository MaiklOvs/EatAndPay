//
//  SearchView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 16.07.2026.
//

import SwiftUI
import DesignSystem

struct SearchView: View {

    @Bindable var searchViewModel: SearchViewModel
    @Bindable var cartViewModel: CartViewModel
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
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 2),
                        GridItem(.flexible(), spacing: 2),
                    ],
                    spacing: 2
                ) {
                    ForEach(searchViewModel.results) { result in
                        ProductCardView(
                            product: result,
                            cartViewModel: cartViewModel
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)

            SearchBar(searchText: $searchViewModel.searchText, action: {
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
    cartViewModel: CartViewModel(networkService: NetworkServicesImpl()))
}
