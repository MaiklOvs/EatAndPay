//
//  CartViewModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import Foundation
import SwiftData

// Корзина

struct Cart {
    let deliveryTime: Int
    var orderPrice: Int
    let deliveryPrice: Int
    var totalPrice: Int
    var totalItems: Int
    var items: [CartItem]
}

struct CartItem: Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Int
    let price: Int
    var quantity: Int
    let available: Bool
}
