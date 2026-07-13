//
//  ProductCardModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import Foundation

@Observable
final class ProductCardViewModel {

    private let networkService: NetworkServices

    init(networkService: NetworkServices) {
        self.networkService = networkService
    }

    var productCard: ProductCardModel?

    func loadProductDetails(id: String) async {
        do {
            let product = try await networkService.fetchProductDetails(query: Operations.get_sol_products_sol__lcub_id_rcub_.Input(path: Operations.get_sol_products_sol__lcub_id_rcub_.Input.Path(id: id)))
            productCard = ProductCardModel(
                id: product.id,
                image: product.image,
                name: product.name,
                weight: product.weight,
                price: product.price,
                rating: product.rating,
                description: product.description,
                isFavorite: product.isFavorite,
                discount: product.discount,
                reviews: product.reviews?.map { item in
                    Review(
                        rating: item.rating,
                        author: item.author,
                        createdAt: item.createdAt,
                        content: item.content,
                        images: item.images
                    )
                }
            )

        } catch {
            print("Failed to load products list: \(error)")
        }
    }
}

// Для детального экрана КТ
struct ProductCardModel: Codable, Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Double
    let price: Int
    let rating: Float
    let description: String
    let isFavorite: Bool
    let discount: Double?
    let reviews: [Review]?
}

struct Review: Codable {
    let rating: Int
    let author: String
    let createdAt: Date
    let content: String
    let images: [String]
}
