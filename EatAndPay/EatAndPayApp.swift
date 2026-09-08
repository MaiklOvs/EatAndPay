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
    private let container: ModelContainer

    init() {
        let networkService = NetworkServicesImpl()
        self.networkService = networkService
        self.favoritesService = FavoritesService(networkServices: networkService)
        self.catalogService = CatalogService(
            networkService: networkService,
            favoritesService: favoritesService
        )
        self.catalogModel = CatalogModel(catalogService: catalogService)
        do {
            container = try ModelContainer(for: PersistedCart.self, PersistedCartItem.self)
        } catch {
            fatalError("Failed to create SwiftData ModelContainer for PersistedCart models: \(error)")
        }
        self.cartService = CartService(
            cartActor: CartActor(
                container: container,
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
                    .modelContainer(container)
                    .environmentObject(snackbarManager)
            }
        }
    }
}
