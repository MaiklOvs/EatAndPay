//
//  NetworkServices.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import OpenAPIRuntime

protocol NetworkServices {

    func fetchCategories() async throws -> [Components.Schemas.Category]
    func fetchProductsList(query: Operations.get_sol_products.Input.Query) async throws -> Operations.get_sol_products.Output.Ok.Body.jsonPayload
    func fetchCart() async throws -> Operations.get_sol_cart.Output.Ok.Body.jsonPayload
    func fetchProductDetails(query: Operations.get_sol_products_sol__lcub_id_rcub_.Input) async throws -> Components.Schemas.Product
    func addItemInCart(query: String) async throws -> Operations.post_sol_cart_sol_items.Output.Ok.Body.jsonPayload
    func removeItemInCart(query: String) async throws -> Operations.delete_sol_cart_sol_items_sol__lcub_id_rcub_.Output.Ok.Body.jsonPayload
}
