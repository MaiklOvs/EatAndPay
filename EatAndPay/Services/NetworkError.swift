//
//  NetworkError.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.07.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case unauthorized        // HTTP 401
    case unexpectedStatus(Int)  // любой другой необработанный статус

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            "Не авторизован"
        case .unexpectedStatus(let code):
            "Неожиданный статус: \(code)"
        }
    }
}
