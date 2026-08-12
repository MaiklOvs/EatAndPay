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
                reviews: product.reviews?.enumerated().map { index, item in
                    Review(
                        id: "\(item.author)_\(item.createdAt)_\(index)",
                        rating: item.rating,
                        author: item.author,
                        createdAt: item.createdAt.formatted(),
                        content: item.content,
                        images: item.images
                    )
                }
            )

        } catch {
            print("Failed to load products list: \(error)")
        }
    }

    func addReview(
        id: String,
        rating: Int,
        content: String,
        images: [String] = []
    ) async {
        do {
            _ = try await networkService.addReviews(
                productId: id,
                rating: rating,
                content: content,
                images: images
            )
            await loadProductDetails(id: id)
        } catch {
            print("Failed to add review: \(error)")
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

struct Review: Codable, Hashable, Identifiable {
    let id: String
    let rating: Int
    let author: String
    let createdAt: String
    let content: String
    let images: [String]
}
