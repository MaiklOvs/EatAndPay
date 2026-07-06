//
//  ProductCardModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

// Для детального экрана КТ
struct ProductCardModel: Codable, Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Int
    let price: Int
    let rating: Double
    let description: String
    let isFavorite: Bool
    let discount: Int?
    let reviews: [Review]
}

struct Review: Codable {
    let rating: Int
    let author: String
    let createdAt: String
    let content: String
    let images: [String]
}
