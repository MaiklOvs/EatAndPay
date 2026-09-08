//
//  OrderModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 17.08.2026.
//

import Foundation

@Observable
final class OrderViewModel {

    private let networkService: NetworkServices
    var orders: [OrderModel] = []
    var isLoading = false

    init(networkService: NetworkServices) {
        self.networkService = networkService
    }

    func loadOrders() async {
        do {
            orders = try await networkService.getOrders().map { order in
                OrderModel(
                    id: order.id,
                    status: OrderStatus(rawValue: order.status.rawValue) ?? .active,
                    deliveryDate: order.deliveryDate,
                    address: OrderAddressModel(
                        coordinates: order.address.coordinates,
                        addressLine: order.address.addressLine,
                        floor: order.address.floor,
                        entrance: order.address.entrance,
                        intercomCode: order.address.intercomCode,
                        comment: order.address.comment
                    ),
                    orderPrice: order.orderPrice,
                    deliveryPrice: order.deliveryPrice,
                    totalPrice: order.totalPrice,
                    totalItems: order.totalItems,
                    items: order.items.map { item in
                        OrderItemModel(
                            id: item.id,
                            image: item.image,
                            name: item.name,
                            weight: item.weight,
                            price: item.price,
                            quantity: item.quantity
                        )
                    }
                )
            }
        } catch {
            print("Failed to load orders: \(error)")
        }
    }
}

struct OrderModel: Identifiable {
    let id: String
    let status: OrderStatus
    let deliveryDate: String?
    let address: OrderAddressModel
    let orderPrice: Int
    let deliveryPrice: Int
    let totalPrice: Int
    let totalItems: Int
    let items: [OrderItemModel]
}

enum OrderStatus: String {
    case active
    case completed
}

struct OrderAddressModel {
    let coordinates: [Double]
    let addressLine: String
    let floor: String?
    let entrance: String?
    let intercomCode: String?
    let comment: String?
}

struct OrderItemModel: Identifiable {
    let id: String
    let image: String
    let name: String
    let weight: Int
    let price: Int
    let quantity: Int
}


