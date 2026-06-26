//
//  NetworkServices.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import OpenAPIRuntime

protocol NetworkServices {
    func fetchProducts() -> Components.Schemas.ProductPreview

    func fetchCart() -> Components.Schemas.Product

    func fetchOrder() -> Components.Schemas.Order
}
