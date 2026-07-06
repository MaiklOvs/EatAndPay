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
    @State private var path = NavigationPath()

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
            .navigationDestination(for: CatalogCard.self) { category in
                ProductListView(
                    catalogModel: catalogModel,
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
