//
//  CartView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem

struct CartView: View {

    @Bindable var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss

    func countString(totalItems: Int?) -> String {
        let items = totalItems ?? 0
        return items > 0 ? "\(items) · товарa" : "\(items) · товаров"
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Корзина")
                    .font(DSTypography.hugeTitle)

                Text("4")
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)

                CloseButton(action: { dismiss() } )
                    .padding(.leading, 188)
            }

            HStack {
                Text("\(cartViewModel.cart?.deliveryTime.formatted() ?? "0") минут")
                Text(countString(totalItems: cartViewModel.cart?.totalItems))
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(cartViewModel.cart?.items ?? []) { item in
                        ProductInCart(cartItem: CartItem(
                            id: item.id,
                            image: item.image,
                            name: item.name,
                            weight: item.weight,
                            price: item.price,
                            quantity: item.quantity,
                            available: item.available
                        ))
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .task {
            await cartViewModel.loadCart()
        }
    }
}

#Preview {
    CartView(cartViewModel: CartViewModel(networkService: NetworkServicesImpl()))
}
