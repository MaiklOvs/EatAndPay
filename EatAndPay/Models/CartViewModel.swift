//
//  CartViewModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import Foundation

// Корзина

@Observable
final class CartViewModel {

    private let networkService: NetworkServices

    var cart: Cart?

    init(networkService: NetworkServices) {
        self.networkService = networkService
    }

    func quantity(for productId: String) -> Int {
        cart?.items.first { $0.id == productId }?.quantity ?? 0
    }

    func totalPrice() -> Int {
        cart?.items.reduce(0) { $0 + $1.price * $1.quantity } ?? 0
    }

    func totalCount() -> Int {
        cart?.items.count ?? 0
    }

    @MainActor
    func add(product: ProductPreviewModel) {
        let productId = product.id
        let productPrice = product.price
        let productImage = product.image
        let productName = product.name
        let productWeight = Int(product.weight)

        var cart = cart ?? Cart(
            deliveryTime: 0,
            orderPrice: 0,
            deliveryPrice: 0,
            totalPrice: 0,
            totalItems: 0,
            items: []
        )

        if let index = cart.items.firstIndex(where: { $0.id == productId }) {
            cart.items[index].quantity += 1
        } else {
            cart.items.append(
                CartItem(
                    id: productId,
                    image: productImage,
                    name: productName,
                    weight: productWeight,
                    price: productPrice,
                    quantity: 1,
                    available: true
                )
            )
        }

        cart.totalItems += 1
        cart.orderPrice += productPrice
        cart.totalPrice += productPrice
        self.cart = cart

        Task { [weak self, productId] in
            await self?.addItemInCart(id: productId)
        }
    }

    @MainActor
    func remove(product: ProductPreviewModel) {
        let productId = product.id
        let productPrice = product.price

        guard let index = cart?.items.firstIndex(where: { $0.id == productId }),
              cart?.items[index].quantity ?? 0 > 0 else { return }

        guard var cart else { return }

        cart.items[index].quantity -= 1

        if cart.items[index].quantity == 0 {
            cart.items.remove(at: index)
        }

        cart.totalItems -= 1
        cart.orderPrice -= productPrice
        cart.totalPrice -= productPrice
        self.cart = cart

        Task { [weak self, productId] in
            await self?.removeItemInCart(id: productId)
        }
    }

    @MainActor
    func add(productId: String, price: Int) {
        var cart = cart ?? Cart(
            deliveryTime: 0,
            orderPrice: 0,
            deliveryPrice: 0,
            totalPrice: 0,
            totalItems: 0,
            items: []
        )

        if let index = cart.items.firstIndex(where: { $0.id == productId }) {
            cart.items[index].quantity += 1
        }

        cart.totalItems += 1
        cart.orderPrice += price
        cart.totalPrice += price
        self.cart = cart

        Task { [weak self, productId] in
            await self?.addItemInCart(id: productId)
        }
    }

    @MainActor
    func remove(productId: String, price: Int) {
        guard let index = cart?.items.firstIndex(where: { $0.id == productId }),
              cart?.items[index].quantity ?? 0 > 0 else { return }

        guard var cart else { return }

        cart.items[index].quantity -= 1

        if cart.items[index].quantity == 0 {
            cart.items.remove(at: index)
        }

        cart.totalItems -= 1
        cart.orderPrice -= price
        cart.totalPrice -= price
        self.cart = cart

        Task { [weak self, productId] in
            await self?.removeItemInCart(id: productId)
        }
    }

    func loadCart() async {
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
        } catch {
            print("Failed to load cart: \(error)")
        }
    }

    func addItemInCart(id: String) async {
        do {
            let cartItem = try await networkService.addItemInCart(query: id)
            cart?.totalItems = cartItem.total
        } catch {
            print("Failed to add item in cart: \(error)")
        }
    }

    func removeItemInCart(id: String) async {
        do {
            let cartItem = try await networkService.removeItemInCart(query: id)
            cart?.totalItems = cartItem.total ?? 0
        } catch {
            print("Failed to remove item in cart: \(error)")
        }
    }
}

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
