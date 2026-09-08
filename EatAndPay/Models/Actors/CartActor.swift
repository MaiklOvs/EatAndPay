//
//  CartActor.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 12.08.2026.
//

import SwiftData
import os.log
import Foundation

actor CartActor {

    private let logger = Logger(subsystem: "com.eatandpay.cart", category: "CartActor")

    private let container: ModelContainer

    var cart: Cart?
    private let networkService: NetworkServices

    init(container: ModelContainer, networkService: NetworkServices) {
        self.container = container
        self.networkService = networkService
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

    // MARK: - Add items in cart

    func addItemInCart(id: String) async throws {
        do {
            let cartItem = try await networkService.addItemInCart(query: id)
            cart?.totalItems = cartItem.total
        } catch {
            logger.error("Failed to add item in cart: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    // MARK: - Public Methods

    func add(product: ProductPreviewModel) async -> Cart? {
        let productId = product.id
        let productPrice = product.price
        let productImage = product.image
        let productName = product.name
        let productWeight = Int(product.weight)

        let cartItem = CartItem(
            id: productId,
            image: productImage,
            name: productName,
            weight: productWeight,
            price: productPrice,
            quantity: 1,
            available: true
        )

        return await addItemToCart(
            productId: productId,
            price: productPrice,
            cartItem: cartItem,
            shouldCreateNewItem: true
        )
    }

    func add(productId: String, price: Int) async -> Cart? {
        return await addItemToCart(
            productId: productId,
            price: price,
            cartItem: nil,
            shouldCreateNewItem: false
        )
    }

    // MARK: - Private Methods

    private func addItemToCart(
        productId: String,
        price: Int,
        cartItem: CartItem?,
        shouldCreateNewItem: Bool
    ) async -> Cart? {
        if cart == nil {
            cart = Cart(
                deliveryTime: 0,
                orderPrice: 0,
                deliveryPrice: 0,
                totalPrice: 0,
                totalItems: 0,
                items: []
            )
        }

        guard var cart = self.cart else { return nil }

        if let index = cart.items.firstIndex(where: { $0.id == productId }) {
            cart.items[index].quantity += 1
        } else if shouldCreateNewItem, let newItem = cartItem {
            cart.items.append(newItem)
        }

        cart.totalItems += 1
        cart.orderPrice += price
        cart.totalPrice += price
        self.cart = cart

        saveCartToLocalIfNeeded()

        do {
            try await self.addItemInCart(id: productId)
        } catch {
            logger.error("Failed to sync added item with server: \(error.localizedDescription, privacy: .public)")
        }

        return cart
    }

    private func saveCartToLocalIfNeeded() {
        do {
            try saveCartToLocal()
        } catch {
            logger.error("Failed to save local cart: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Remove item in cart

    func removeItemInCart(id: String) async throws {
        do {
            let cartItem = try await networkService.removeItemInCart(query: id)
            cart?.totalItems = cartItem.total ?? 0
        } catch {
            logger.error("Failed to remove item in cart: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    // MARK: - Public Methods

    func remove(product: ProductPreviewModel) async -> Cart? {
        return await removeItemFromCart(
            productId: product.id,
            price: product.price
        )
    }

    func remove(productId: String, price: Int) async -> Cart? {
        return await removeItemFromCart(
            productId: productId,
            price: price
        )
    }

    // MARK: - Private Methods

    private func removeItemFromCart(
        productId: String,
        price: Int
    ) async -> Cart? {
        guard let index = cart?.items.firstIndex(where: { $0.id == productId }),
              let cartItems = cart?.items,
              index < cartItems.count,
              cartItems[index].quantity > 0 else {
            return cart
        }

        guard var cart = cart else { return cart }

        cart.items[index].quantity -= 1

        if cart.items[index].quantity == 0 {
            cart.items.remove(at: index)
        }

        cart.totalItems -= 1
        cart.orderPrice -= price
        cart.totalPrice -= price
        self.cart = cart

        saveCartToLocalIfNeeded()

        do {
            try await self.removeItemInCart(id: productId)
        } catch {
            logger.error("Failed to sync removed item with server: \(error.localizedDescription, privacy: .public)")
        }

        return cart
    }

    // MARK: - Load cart

    func loadCart() async -> Cart? {
        do {
            if let localCart = try loadCartFromLocal() {
                cart = localCart
            }
        } catch {
            logger.error("Failed to load local cart: \(error.localizedDescription, privacy: .public)")
        }
        do {
            let cartList = try await networkService.fetchCart()
            cart = Cart(
                deliveryTime: cartList.deliveryTime,
                orderPrice: cartList.orderPrice,
                deliveryPrice: cartList.deliveryPrice,
                totalPrice: cartList.totalPrice,
                totalItems: cartList.totalItems,
                items: cartList.items.map { item in
                    CartItem(
                        id: item.value1.id,
                        image: item.value1.image,
                        name: item.value1.name,
                        weight: item.value1.weight,
                        price: item.value1.price,
                        quantity: item.value1.quantity,
                        available: item.value2.available
                    )
                }
            )
            try saveCartToLocal()
        } catch {
            logger.error("Failed to load cart: \(error.localizedDescription, privacy: .public)")
        }

        return cart
    }

    // MARK: - Make order

    func makeOrder(paymentMethod: String, addressID: String) async -> Bool {
        do {
            let _ = try await networkService.makeOrder(paymentMethod: paymentMethod, addressID: addressID)

            let localCart = try fetchPersistedCart()
            let context = ModelContext(container)

            if let localCart {
                context.delete(localCart)
                try context.save()
            }
            cart = nil
            return true
        } catch {
            logger.error("Failed to make order: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    // MARK: - SwiftData actions

    private func fetchPersistedCart() throws -> PersistedCart? {
        let fetchDescriptor = FetchDescriptor<PersistedCart>()
        let context = ModelContext(container)

        let persistedCart = try context.fetch(fetchDescriptor)
        return persistedCart.first
    }

    private func cleanPersistedCart(context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<PersistedCart>()

        let persistedCart = try context.fetch(fetchDescriptor)

        for item in persistedCart {
            context.delete(item)
        }
    }

    private func saveCartToLocal() throws {
        let context = ModelContext(container)

        try cleanPersistedCart(context: context)

        if let cart {
            let persistedCart = PersistedCart(
                deliveryTime: cart.deliveryTime,
                orderPrice: cart.orderPrice,
                deliveryPrice: cart.deliveryPrice,
                totalPrice: cart.totalPrice,
                totalItems: cart.totalItems,
                items: cart.items.map { item in
                    PersistedCartItem(
                        id: item.id,
                        image: item.image,
                        name: item.name,
                        weight: item.weight,
                        price: item.price,
                        quantity: item.quantity,
                        available: item.available
                    )
                }
            )
            context.insert(persistedCart)
            try context.save()
        }
    }

    private func loadCartFromLocal() throws -> Cart? {
        let persistedCart = try fetchPersistedCart()

        guard let persistedCart else { return nil }

        let cart = Cart(
            deliveryTime: persistedCart.deliveryTime,
            orderPrice: persistedCart.orderPrice,
            deliveryPrice: persistedCart.deliveryPrice,
            totalPrice: persistedCart.totalPrice,
            totalItems: persistedCart.totalItems,
            items: persistedCart.items.map { item in
                CartItem(
                    id: item.id,
                    image: item.image,
                    name: item.name,
                    weight: item.weight,
                    price: item.price,
                    quantity: item.quantity,
                    available: item.available
                )
            }
        )
        return cart
    }
}
