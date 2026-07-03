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

    var body: some View {
        NavigationStack {
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
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(catalogModel.products) { product in
                                ProductCardView(product: product)
                            }
                        }
                        .padding(10)
                    }
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
                                    CatalogCardsView(catalogCardModel: category)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .task {
                        await catalogModel.loadCategories()
                    }

                case .discounts:
                    Text("Скидки")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    Text("Избранное")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("")
        }
    }
}

#Preview {
    CatalogView()
}
