//
//  CatalogModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import Foundation

@Observable
final class CatalogModel {
    
    enum Tab: Int, CaseIterable {
        case forYou = 0
        case catalog = 1
        case discounts = 2
        case favorites = 3
    }

    var selectedTab = Tab.catalog

    private let networkService: NetworkServices

    var products: Products = Products(currentPage: 1, totalPages: 1, data: [])

    var categories: [CatalogCard] = []

    init(networkService: NetworkServices) {
        self.networkService = networkService
    }

    func loadCategories() async {
        do {
            let categoriesList = try await networkService.fetchCategories()
            categories = categoriesList.map { item in
                CatalogCard(
                    id: item.id,
                    name: item.name,
                    image: item.image
                )
            }
        } catch {
            print("Failed to load categories: \(error)")
        }
    }

    func loadProductsList(query: Operations.get_sol_products.Input.Query = .init()) async {
        do {
            let productsList = try await networkService.fetchProductsList(query: query)
            products = Products(
                currentPage: productsList.currentPage,
                totalPages: productsList.totalPages,
                data: productsList.data.map { item in
                    ProductPreviewModel(
                        id: item.id,
                        image: item.image,
                        name: item.name,
                        weight: item.weight,
                        price: item.price,
                        rating: item.rating,
                        reviewCount: item.reviewCount,
                        isFavorite: item.isFavorite,
                        discount: item.discount
                    )
                }
            )
        } catch {
            print("Failed to load products list: \(error)")
        }
    }

    func toggleFavorite(for productId: String) async {
        guard let index = products.data.firstIndex(where: { $0.id == productId }) else { return }
        let product = products.data[index]
        let makeFavorite = !product.isFavorite

        do {
            if makeFavorite {
                try await networkService.addToFavorites(productId: productId)
            } else {
                try await networkService.removeFromFavorites(productId: productId)
            }
            var updated = product
            updated.isFavorite = makeFavorite
            products.data[index] = updated
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }
}

