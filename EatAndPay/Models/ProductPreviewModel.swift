//
//  ProductPreviewModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

// Для списка КТ в каталоге
struct Products {
    let currentPage: Int
    let totalPages: Int
    let data: [ProductPreviewModel]
}

struct ProductPreviewModel: Codable, Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Double
    let price: Int
    let rating: Float
    let reviewCount: Int
    let isFavorite: Bool
    let discount: Double?
}
