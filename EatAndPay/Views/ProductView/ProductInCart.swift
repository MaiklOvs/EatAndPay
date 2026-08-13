//
//  ProductInCart.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ProductInCart: View {

    let cartItem: CartItem
    var cartViewModel: CartViewModel?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cartItem.image)) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(cartItem.price.formatted() + " ₽")
                HStack {
                    Text(cartItem.name)
                    Text(cartItem.weight.formatted() + " г")
                        .foregroundStyle(DSColors.textSecondary)
                }
                CountButton(
                    count: cartItem.quantity,
                    onDecrement: {
                        Task {
                            await cartViewModel?.remove(productId: cartItem.id, price: cartItem.price)
                        }
                    },
                    onIncrement: {
                        Task {
                            await cartViewModel?.add(productId: cartItem.id, price: cartItem.price)
                        }
                    }
                )
            }
            .padding(.bottom, 21)
        }
    }
}

#Preview {
    ProductInCart(cartItem: CartItem(
        id: "1",
        image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/bread.jxl",
        name: "Огурец",
        weight: 100,
        price: 900,
        quantity: 1,
        available: true
    ),
                  cartViewModel:
                    CartViewModel(
                        cartActor: CartActor(
                            container: try! ModelContainer(for: PersistedCart.self, PersistedCartItem.self),
                            networkService: NetworkServicesImpl()
                        )
                    )
    )
}
