//
//  ProductService.swift
//  EatAndPay
//
//  Created by Kilo Code on 15.08.2026.
//

import Foundation

@MainActor
@Observable
final class ProductService {

    private let networkService: NetworkServices

    var productCard: ProductCardModel?
    var isLoadingCartDetail: Bool
    var isLoadingAddReview: Bool

    init(
        networkService: NetworkServices,
        isLoadingCartDetail: Bool = false,
        isLoadingAddReview: Bool = false
    ) {
        self.networkService = networkService
        self.isLoadingCartDetail = isLoadingCartDetail
        self.isLoadingAddReview = isLoadingAddReview
    }

    func loadProductDetails(id: String) async {
        defer { isLoadingCartDetail = false }
        do {
            isLoadingCartDetail = true
            let product = try await networkService.fetchProductDetails(
                query: Operations.get_sol_products_sol__lcub_id_rcub_.Input(
                    path: Operations.get_sol_products_sol__lcub_id_rcub_.Input.Path(id: id)
                )
            )
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
            print("Failed to load product details: \(error)")
        }
    }

    func addReview(
        id: String,
        rating: Int,
        content: String,
        images: [String] = []
    ) async {
        defer { isLoadingAddReview = false }
        do {
            isLoadingAddReview = true
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
