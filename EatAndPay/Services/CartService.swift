//
//  CartService.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 14.08.2026.
//

import Foundation
import os.log

@MainActor
@Observable
final class CartService {

    private let cartActor: CartActor
    private let logger = Logger(subsystem: "com.eatandpay.cart", category: "CartService")

    var cart: Cart?
    var isMakingOrder = false
    var loadingItemIds: Set<String> = []
    var lastError: Error?

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
        loadingItemIds.insert(product.id)
        defer { loadingItemIds.remove(product.id) }
        do {
            cart = try await cartActor.add(product: product)
        } catch {
            logError(error, context: "add product \(product.id)")
        }
    }

    func remove(product: ProductPreviewModel) async {
        loadingItemIds.insert(product.id)
        defer { loadingItemIds.remove(product.id) }
        do {
            cart = try await cartActor.remove(product: product)
        } catch {
            logError(error, context: "remove product \(product.id)")
        }
    }

    func add(productId: String, price: Int) async {
        loadingItemIds.insert(productId)
        defer { loadingItemIds.remove(productId) }
        do {
            cart = try await cartActor.add(productId: productId, price: price)
        } catch {
            logError(error, context: "add product \(productId)")
        }
    }

    func remove(productId: String, price: Int) async {
        loadingItemIds.insert(productId)
        defer { loadingItemIds.remove(productId) }
        do {
            cart = try await cartActor.remove(productId: productId, price: price)
        } catch {
            logError(error, context: "remove product \(productId)")
        }
    }

    func loadCart() async {
        cart = await cartActor.loadCart()
    }

    private func logError(_ error: Error, context: String) {
        lastError = error
        logger.error("Failed to \(context, privacy: .public): \(error.localizedDescription, privacy: .public)")
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
