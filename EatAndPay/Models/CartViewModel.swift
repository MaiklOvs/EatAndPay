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

    func add(product: ProductPreviewModel) {
        var cart = cart ?? Cart(
            deliveryTime: 0,
            orderPrice: 0,
            deliveryPrice: 0,
            totalPrice: 0,
            totalItems: 0,
            items: []
        )

        if let index = cart.items.firstIndex(where: { $0.id == product.id }) {
            cart.items[index].quantity += 1
        } else {
            cart.items.append(
                CartItem(
                    id: product.id,
                    image: product.image,
                    name: product.name,
                    weight: Int(product.weight),
                    price: product.price,
                    quantity: 1,
                    available: true
                )
            )
        }

        cart.totalItems += 1
        cart.orderPrice += product.price
        cart.totalPrice += product.price
        self.cart = cart
    }

    func remove(product: ProductPreviewModel) {
        guard var cart,
              let index = cart.items.firstIndex(where: { $0.id == product.id }),
              cart.items[index].quantity > 0 else { return }

        cart.items[index].quantity -= 1

        if cart.items[index].quantity == 0 {
            cart.items.remove(at: index)
        }

        cart.totalItems -= 1
        cart.orderPrice -= product.price
        cart.totalPrice -= product.price
        self.cart = cart
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
            print("Failed to load products list: \(error)")
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
