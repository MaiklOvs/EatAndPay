//
//  ClientConfiguration.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 29.07.2026.
//

import OpenAPIRuntime
import Foundation

enum ClientConfiguration {
    static func make() -> Configuration {
        Configuration(dateTranscoder: CustomDateTranscoder())
    }
}

struct CustomDateTranscoder: DateTranscoder {

    func encode(_ date: Date) throws -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }

    func decode(_ string: String) throws -> Date {
        // 1. Пробуем стандартный ISO8601 без дробных секунд
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: string) {
            return date
        }

        // 2. Пробуем ISO8601 с дробными секундами
        let isoFormatterWithFractions = ISO8601DateFormatter()
        isoFormatterWithFractions.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatterWithFractions.date(from: string) {
            return date
        }

        // 3. Fallback на DateFormatter с timezone
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = fallbackFormatter.date(from: string) {
            return date
        }

        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [],
                debugDescription: "Cannot decode date string: \(string)"
            )
        )
    }
}
