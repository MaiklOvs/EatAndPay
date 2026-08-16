//
//  CartService.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 14.08.2026.
//

import Foundation

@MainActor
@Observable
final class CartService {

    private let cartActor: CartActor
    var cart: Cart?
    var isMakingOrder = false

    init(cartActor: CartActor, cart: Cart? = nil) {
        self.cartActor = cartActor
        self.cart = cart
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
        isMakingOrder = true
        defer { isMakingOrder = false }
        let success = await cartActor.makeOrder(paymentMethod: paymentMethod, addressID: addressID)
        if success {
            self.cart = nil
        }
        return success
    }
}
