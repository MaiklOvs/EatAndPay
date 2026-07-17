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

    func countString(count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(count) товаров"
        }

        switch lastDigit {
        case 1:
            return "\(count) товар"
        case 2, 3, 4:
            return "\(count) товара"
        default:
            return "\(count) товаров"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text("Корзина")
                    .font(DSTypography.hugeTitle)
                    .padding(.top, 10)
                Text(cartViewModel.totalCount().formatted())
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)
                    .padding(.top, 10)
                Spacer()
                CloseButton(action: { dismiss() } )
            }

            HStack {
                Text("\(cartViewModel.cart?.deliveryTime.formatted() ?? "0") минут")
                Text(countString(count: cartViewModel.totalCount()))
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
            HStack(spacing: 10) {
                Text("Итого:")
                    .font(DSTypography.hugeTitle)
                    .padding(.top, 10)
                Text(cartViewModel.totalPrice().formatted() + " ₽")
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)
                    .padding(.top, 10)
            }
            CheckoutButton(
                price: cartViewModel.totalPrice(),
                count: cartViewModel.totalCount(),
                isExpanded: true,
                action: {}
            )
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
