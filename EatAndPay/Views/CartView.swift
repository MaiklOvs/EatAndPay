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
            HStack(spacing: 10) {
                Text("Корзина")
                    .font(DSTypography.hugeTitle)
                    .padding(.top, 10)
                Text(cartViewModel.cart?.items.count.formatted() ?? "0")
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)
                    .padding(.top, 10)
                Spacer()
                CloseButton(action: { dismiss() } )
            }

            HStack {
                Text("\(cartViewModel.cart?.deliveryTime.formatted() ?? "0") минут")
                Text(countString(totalItems: cartViewModel.cart?.items.count))
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(cartViewModel.cart?.items ?? []) { item in
                        ProductInCart(cartItem: CartItem(
                            id: item.id,
                            image: item.image,
                            name: item.name,
                            weight: item.weight * item.quantity,
                            price: item.price * item.quantity,
                            quantity: item.quantity,
                            available: item.available
                        ), cartViewModel: cartViewModel)
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
