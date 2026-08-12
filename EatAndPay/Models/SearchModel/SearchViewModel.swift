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

    var searchHistory: [String] = []

    var suggestions: [String] {
        guard !searchText.isEmpty else { return [] }
        let matches = allProducts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        return Array(Set(matches.map(\.name))).sorted()
    }

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
