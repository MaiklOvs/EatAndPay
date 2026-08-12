//
//  CartView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem

struct CartView: View {

    private let addressModel: AddressModel

    @Bindable var cartViewModel: CartViewModel

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var snackbarManager: SnackbarManager

    @State private var isAddNewAddressPresented = false
    @State private var isSuccessOrderPresented = false

    init(addressModel: AddressModel, cartViewModel: CartViewModel) {
        self.addressModel = addressModel
        self.cartViewModel = cartViewModel
    }

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
        ZStack(alignment: .bottom) {
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
                        .padding(.trailing, 20)
                        .padding(.top, 10)
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
                Button {
                    isAddNewAddressPresented = true
                } label: {
                    AddressView(address: addressModel)
                }
                .buttonStyle(.plain)
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
                    action: {
                        Task {
                            let success = await cartViewModel.makeOrder(
                                paymentMethod: "card",
                                addressID: addressModel.selectedAddress?.id ?? ""
                            )
                            if success {
                                isSuccessOrderPresented = true
                            } else {
                                snackbarManager.show(title: "Не удалось оформить заказ, попробуйте еще раз")
                            }
                        }
                    }
                )
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .sheet(isPresented: $isAddNewAddressPresented) {
                AddressListView(addressModel: addressModel)
            }
            .sheet(isPresented: $isSuccessOrderPresented) {
                SuccessView(
                    title: "Заказ оформлен",
                    subtitle: "Товары уже в процессе сборки, скоро привезём!",
                    action: { dismiss() }
                )
            }
            .task {
                await cartViewModel.loadCart()
            }

            if let message = snackbarManager.message {
                SnackBar(title: message)
                    .padding(.bottom, 60)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: snackbarManager.message)
    }
}

#Preview {
    CartView(
        addressModel: AddressModel(networkService: NetworkServicesImpl()),
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl())
    )
}
