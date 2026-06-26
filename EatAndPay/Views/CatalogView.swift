//
//  CatalogView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import DesignSystem

struct CatalogView: View {

    @State private var viewModel = CatalogModel()


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextTabBar(
                    selectedIndex: viewModel.selectedTab,
                    tabs: ["Для тебя", "Каталог", "Скидки", "Избранное"]
                )
                .padding(.top, 60)

                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(viewModel.products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(10)
                }
            }
            .navigationTitle("")
        }
    }
}

#Preview {
    CatalogView()
}
