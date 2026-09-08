//
//  String+PhoneFormatter.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 24.08.2026.
//

extension String {
    var asPhoneNumber: String {
        let digits = self.filter { $0.isNumber }
        guard digits.count >= 11 else { return self }

        let normalized = digits.first == "8" ? "7" + digits.dropFirst() : digits
        let country = normalized.prefix(1)
        let part1 = normalized.dropFirst(1).prefix(3)
        let part2 = normalized.dropFirst(4).prefix(3)
        let part3 = normalized.dropFirst(7).prefix(2)
        let part4 = normalized.dropFirst(9).prefix(2)

        return "+\(country) \(part1) \(part2)-\(part3)-\(part4)"
    }
}
