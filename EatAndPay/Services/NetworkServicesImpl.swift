//
//  NetworkServicesImpl.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.07.2026.
//
import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

final class NetworkServicesImpl: NetworkServices {

    let client = Client(
        serverURL: URL(string: "https://eat-and-pay.t02.ru")!,
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(bearerToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJta29uZGFrb3ZhIiwiaWF0IjoxNzgyOTIyMDM3LCJqdGkiOiJlYjU1MTNkZi1jM2FmLTQ5NjktOWU5OC03MGJkNThmNDQyYmQiLCJuaWNrbmFtZSI6Im92c3lhbm5pa292Lm1pa2hhaWwiLCJpc1RlYWNoZXIiOnRydWV9.OmbqPS-YyVyYbajz2rJDTuZTuLX8riGQkF2XdxyiWO_t76QB-6FEEgpzstlj1TM9weoq-XS_B-R7dhjW_amnOi6tsnV9xN_a0F8B-9KJOMosfX_QsF645byDMwE5ZYNxhLPW0bWXa3qc1-h4gAhm1Gdtz25Aiy6sX5dy05UrvUPOTrbI_g1FJrIGP2kHHkUX6MQ1fgST5nTqjPnEn5wx26lh6DmLoHL4eyCGeXxquRxAujPA8K0PA2-L3Wrdz3UIeElP9XfAJZRpU9OcSyXYH5J-A96gINFkSdEZ5CZlWpt99_n3Bc_sCbJUzHX3OsgLRW3fF-gkn6cD-5g-2jEZ0Q")]
    )

    func fetchCategories() async throws -> [Components.Schemas.Category] {
        let response = try await client.get_sol_categories()
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        }
    }

    func fetchProductsList(query: Operations.get_sol_products.Input.Query = .init()) async throws -> Operations.get_sol_products.Output.Ok.Body.jsonPayload {
        let response = try await client.get_sol_products(Operations.get_sol_products.Input(query: query))
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        case .badRequest(_):
            throw NetworkError.badRequest
        }
    }

    func fetchCart() async throws -> Operations.get_sol_cart.Output.Ok.Body.jsonPayload {
        let response = try await client.get_sol_cart()
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        }
    }

    func addItemInCart(query: String) async throws -> Operations.post_sol_cart_sol_items.Output.Ok.Body.jsonPayload {
        let response = try await client.post_sol_cart_sol_items(Operations.post_sol_cart_sol_items.Input(query: Operations.post_sol_cart_sol_items.Input.Query(id: query)))
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        case .notFound(_):
            throw NetworkError.notFound
        }
    }

    func removeItemInCart(query: String) async throws -> Operations.delete_sol_cart_sol_items_sol__lcub_id_rcub_.Output.Ok.Body.jsonPayload {
        let response = try await client.delete_sol_cart_sol_items_sol__lcub_id_rcub_(Operations.delete_sol_cart_sol_items_sol__lcub_id_rcub_.Input(path: Operations.delete_sol_cart_sol_items_sol__lcub_id_rcub_.Input.Path(id: query)))
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        case .notFound(_):
            throw NetworkError.notFound
        }
    }

    func fetchProductDetails(query: Operations.get_sol_products_sol__lcub_id_rcub_.Input) async throws -> Components.Schemas.Product {
        let response = try await client.get_sol_products_sol__lcub_id_rcub_(query)
        switch response {
        case .ok(let okResponse):
            return try okResponse.body.json
        case .unauthorized:
            throw NetworkError.unauthorized
        case .default(statusCode: let statusCode, _):
            throw NetworkError.unexpectedStatus(statusCode)
        case .notFound(_):
            throw NetworkError.notFound
        }
    }
}
