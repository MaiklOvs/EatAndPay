//
//  PersistedCart.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 11.08.2026.
//

import Foundation
import SwiftData

@Model
final class PersistedCart {
    var deliveryTime: Int
    var orderPrice: Int
    var deliveryPrice: Int
    var totalPrice: Int
    var totalItems: Int

    @Relationship(deleteRule: .cascade, inverse: \PersistedCartItem.cart)
    var items: [PersistedCartItem]

    init(
        deliveryTime: Int = 0,
        orderPrice: Int = 0,
        deliveryPrice: Int = 0,
        totalPrice: Int = 0,
        totalItems: Int = 0,
        items: [PersistedCartItem] = []
    ) {
        self.deliveryTime = deliveryTime
        self.orderPrice = orderPrice
        self.deliveryPrice = deliveryPrice
        self.totalPrice = totalPrice
        self.totalItems = totalItems
        self.items = items
    }
}

@Model
final class PersistedCartItem {
    var id: String
    var image: String
    var name: String
    var weight: Int
    var price: Int
    var quantity: Int
    var available: Bool

    var cart: PersistedCart?

    init(
        id: String,
        image: String,
        name: String,
        weight: Int,
        price: Int,
        quantity: Int,
        available: Bool
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.weight = weight
        self.price = price
        self.quantity = quantity
        self.available = available
    }
}
