//
//  EatAndPayApp.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI

@main
struct EatAndPayApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                CatalogView()
            }
        }
    }
}
