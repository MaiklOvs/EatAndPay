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

@MainActor
@Observable
final class CartViewModel {

    private let cartActor: CartActor

    var cart: Cart?
    var isLoading: Bool = false

    init(
        cartActor: CartActor
    ) {
        self.cartActor = cartActor
    }

    // MARK: - Actions

    func quantity(for productId: String) -> Int {
        cart?.items.first { $0.id == productId }?.quantity ?? 0
    }

    func totalPrice() -> Int {
        cart?.items.reduce(0) { $0 + $1.price * $1.quantity } ?? 0
    }

    func totalCount() -> Int {
        cart?.items.reduce(0) { $0 + $1.quantity } ?? 0
    }

    func add(product: ProductPreviewModel) async {
        cart = await cartActor.add(product: product)
    }

    func remove(product: ProductPreviewModel) async {
        cart = await cartActor.remove(product: product)
    }

    func add(productId: String, price: Int) async {
        cart = await cartActor.add(productId: productId, price: price)
    }

    func remove(productId: String, price: Int) async {
        cart = await cartActor.remove(productId: productId, price: price)
    }

    func loadCart() async {
        cart = await cartActor.loadCart()
    }

    func makeOrder(paymentMethod: String, addressID: String) async -> Bool {
        let success = await cartActor.makeOrder(paymentMethod: paymentMethod, addressID: addressID)
        if success {
            self.cart = nil
        }
        return success
    }
}
