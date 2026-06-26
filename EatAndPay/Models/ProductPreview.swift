//
//  ProductPreview.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

// Для списка КТ в каталоге
struct ProductPreview: Codable, Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Int
    let price: Int
    let rating: Double
    let reviewCount: Int
    let isFavorite: Bool
    let discount: Int?
}
