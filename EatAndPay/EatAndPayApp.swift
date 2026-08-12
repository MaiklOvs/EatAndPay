//
//  EatAndPayApp.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI
import SwiftData
import DesignSystem

@main
struct EatAndPayApp: App {
    @State private var isLoading = true
    let snackbarManager = SnackbarManager()

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                if isLoading {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                            }
                        }
                } else {
                    CatalogView()
                        .modelContainer(for: [PersistedCart.self, PersistedCartItem.self])
                }
                if let message = snackbarManager.message {
                    SnackBar(title: message)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .environment(snackbarManager)
            .animation(.easeInOut(duration: 0.3), value: snackbarManager.message)
        }
    }
}
