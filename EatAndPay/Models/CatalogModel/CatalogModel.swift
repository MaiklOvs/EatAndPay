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
    let favoritesService: FavoritesService

    var products: Products = Products(currentPage: 1, totalPages: 1, data: [])

    var categories: [CatalogCard] = []

    init(networkService: NetworkServices, favoritesService: FavoritesService) {
        self.networkService = networkService
        self.favoritesService = favoritesService
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

    func loadAllProducts(query: Operations.get_sol_products.Input.Query = .init()) async {
        var currentPage = 1
        var allData: [ProductPreviewModel] = []
        var totalPages = 1

        repeat {
            do {
                var pageQuery = query
                pageQuery.page = currentPage
                let productsList = try await networkService.fetchProductsList(query: pageQuery)
                totalPages = productsList.totalPages
                let pageData = productsList.data.map { item in
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
                allData.append(contentsOf: pageData)
                for product in pageData {
                    favoritesService.setFavoriteStatus(productId: product.id, isFavorite: product.isFavorite)
                }
                currentPage += 1
            } catch {
                print("Failed to load products list: \(error)")
                break
            }
        } while currentPage <= totalPages

        products = Products(currentPage: 1, totalPages: totalPages, data: allData)
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
            for product in products.data {
                favoritesService.setFavoriteStatus(productId: product.id, isFavorite: product.isFavorite)
            }
        } catch {
            print("Failed to load products list: \(error)")
        }
    }
}

