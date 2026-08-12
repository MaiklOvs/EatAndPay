//
//  SnackBarManager.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 11.08.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SnackbarManager {
    var message: String? = nil

    func show(title: String, duration: TimeInterval = 3.0) {
        message = title

        Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run { self?.message = nil }
        }
    }
}
