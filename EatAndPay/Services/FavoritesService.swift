//
//  FavoritesService.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 14.08.2026.
//

import Foundation

@Observable
final class FavoritesService {

    private(set) var favoritesItems: Set<String>
    private var networkServices: NetworkServices

    init(favoritesItems: Set<String> = [], networkServices: NetworkServices) {
        self.favoritesItems = favoritesItems
        self.networkServices = networkServices
    }

    func setFavoriteStatus(productId: String, isFavorite: Bool) {
        if isFavorite {
            favoritesItems.insert(productId)
        } else {
            favoritesItems.remove(productId)
        }
    }

    func addToFavorites(productId: String) async {
        do {
            let _ = try await networkServices.addToFavorites(productId: productId)
            favoritesItems.insert(productId)
        } catch {
            print("Failed to add favorite: \(error)")
        }
    }

    func removeFromFavorites(productId: String) async {
        do {
            let _ = try await networkServices.removeFromFavorites(productId: productId)
            favoritesItems.remove(productId)
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }

    func toggleFavorite(for productId: String) async {
        if favoritesItems.contains(productId) {
            await removeFromFavorites(productId: productId)
        } else {
            await addToFavorites(productId: productId)
        }
    }

    func isFavorite(productId: String) -> Bool {
        favoritesItems.contains(productId)
    }
}
