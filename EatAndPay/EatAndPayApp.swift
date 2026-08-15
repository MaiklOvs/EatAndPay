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

    private let networkService: NetworkServices
    private let favoritesService: FavoritesService
    private let catalogService: CatalogService
    private let catalogModel: CatalogModel
    private let cartService: CartService

    init() {
        let networkService = NetworkServicesImpl()
        self.networkService = networkService
        self.favoritesService = FavoritesService(networkServices: networkService)
        self.catalogService = CatalogService(
            networkService: networkService,
            favoritesService: favoritesService
        )
        self.catalogModel = CatalogModel(catalogService: catalogService)
        self.cartService = CartService(
            cartActor: CartActor(
                container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                networkService: networkService
            )
        )
    }

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
                CatalogView(
                    catalogModel: catalogModel,
                    cartService: cartService
                )
                    .modelContainer(for: [PersistedCart.self, PersistedCartItem.self])
                    .environmentObject(snackbarManager)
            }
        }
    }
}
