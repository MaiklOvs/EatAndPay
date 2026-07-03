//
//  AuthMiddleware.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.07.2026.
//

import HTTPTypes
import OpenAPIRuntime
import Foundation

struct AuthenticationMiddleware: ClientMiddleware, Sendable {

    var bearerToken: String

    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @concurrent @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(bearerToken)"
        return try await next(request, body, baseURL)
    }
}
