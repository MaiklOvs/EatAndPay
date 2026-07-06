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
}
