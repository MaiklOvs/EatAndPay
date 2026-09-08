//
//  ProductInOrders.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 13.07.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct ProductInOrders: View {

    var orderModel: OrderItemModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            CachedAsyncImage(
                urlString: orderModel.image,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                },
                placeholder: {
                    DSImagePlaceholder()
                }
            )
            .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(orderModel.price.formatted() + " ₽, \(orderModel.quantity) шт")
                    .font(DSTypography.addressTitle)
                HStack {
                    Text(orderModel.name)
                    Text(orderModel.weight.formatted() + " г")
                        .foregroundStyle(DSColors.textSecondary)
                }
            }
            .padding(.bottom, 21)
        }
    }
}

#Preview {
    ProductInOrders(
        orderModel: OrderItemModel(
            id: "",
            image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
            name: "Эчпочмак",
            weight: 80,
            price: 120,
            quantity: 1
        )
    )
}
