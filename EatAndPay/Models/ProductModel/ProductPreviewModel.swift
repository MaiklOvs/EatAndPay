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
    var data: [ProductPreviewModel]
}

struct ProductPreviewModel: Codable, Identifiable, Equatable {
    let id: String
    let image: String
    let name: String
    let weight: Double
    let price: Int
    let rating: Float
    let reviewCount: Int
    var isFavorite: Bool
    let discount: Double?
}
