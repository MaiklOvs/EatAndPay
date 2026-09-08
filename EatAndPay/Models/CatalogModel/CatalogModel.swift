//
//  CatalogModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import Foundation

@Observable
final class CatalogModel {

    enum Tab: Int, CaseIterable {
        case forYou = 0
        case catalog = 1
        case discounts = 2
        case favorites = 3
    }

    var selectedTab = Tab.catalog

    let catalogService: CatalogService

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }
}
