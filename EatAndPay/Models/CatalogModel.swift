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

    var products: [ProductPreview] = []

    var categories: [CatalogCard] = []

    init(networkService: NetworkServices) {
        products = [
            ProductPreview(id: "1", image: "", name: "Огурец в тесте", weight: 80, price: 750, rating: 3.8, reviewCount: 1356, isFavorite: false, discount: nil),
            ProductPreview(id: "2", image: "", name: "Ролл Филадельфия", weight: 250, price: 450, rating: 4.5, reviewCount: 342, isFavorite: true, discount: 10),
            ProductPreview(id: "3", image: "", name: "Пицца Маргарита", weight: 400, price: 590, rating: 4.2, reviewCount: 567, isFavorite: false, discount: nil),
            ProductPreview(id: "4", image: "", name: "Борщ", weight: 300, price: 320, rating: 4.7, reviewCount: 891, isFavorite: false, discount: 5),
        ]
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
}

