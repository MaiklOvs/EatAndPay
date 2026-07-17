//
//  SearchViewModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 17.07.2026.
//

import Foundation

@Observable
final class SearchViewModel {

    var searchText: String = ""

    var allProducts: [ProductPreviewModel]

    private var searchHistory: [String] = []

    init(allProducts: [ProductPreviewModel]) {
        self.allProducts = allProducts
    }

    var results: [ProductPreviewModel] {
        guard !searchText.isEmpty else { return [] }
        return allProducts.filter { product in
            product.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    func addToHistory(_ query: String) {
        guard !query.isEmpty else { return }
        searchHistory.removeAll { $0 == query }
        searchHistory.insert(query, at: 0)
    }
}
