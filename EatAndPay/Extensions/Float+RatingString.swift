//
//  Float+RatingString.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 25.08.2026.
//

import Foundation

extension Float {
    var ratingString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
