//
//  ProductCardModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import Foundation

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
