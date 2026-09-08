//
//  OrdersDetailView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 17.08.2026.
//

import SwiftUI
import DesignSystem

struct OrderDetailView: View {

    @Environment(\.dismiss) private var dismiss

    var orderModel: OrderModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Доставим\nчерез 12 минут")
                    .font(DSTypography.hugeTitle)
                Spacer()
                CloseButton(action: { dismiss() })
            }
            .padding(.top, 18)
            .padding(.horizontal, 20)
            Text("\(orderModel.address.addressLine)")
                .padding(.horizontal, 20)
            Text("\(orderModel.address.floor ?? "") этаж, \(orderModel.address.entrance ?? "") подъезд, код домофона \(orderModel.address.intercomCode ?? ""), \n\(orderModel.address.comment ?? "")")
                .font(DSTypography.caption)
                .foregroundStyle(DSColors.textSecondary)
                .padding(.horizontal, 20)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(orderModel.items) { item in
                        ProductInOrders(orderModel: item)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            Spacer()
            HStack {
                Text("Итого")
                    .font(DSTypography.addressTitle)
                Spacer()
                Text("\(orderModel.totalPrice)  ₽")
                    .font(DSTypography.addressTitle)
            }
            .padding(.horizontal, 12)
            HStack {
                Text("\(orderModel.totalItems) товаров")
                    .font(DSTypography.caption)
                Spacer()
                Text("\(orderModel.orderPrice)  ₽")
                    .font(DSTypography.caption)
            }
            .padding(.horizontal, 12)
            HStack {
                Text("Доставка")
                    .font(DSTypography.caption)
                Spacer()
                Text("\(orderModel.deliveryPrice)  ₽")
                    .font(DSTypography.caption)
            }
            .padding(.horizontal, 12)
            HStack {
                DSButton(
                    action: {},
                    buttonTitle: "Скачать чек",
                    style: .inputAddress
                )
                DSButton(
                    action: {},
                    buttonTitle: "Повторить заказ"
                )
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    OrderDetailView(
        orderModel: OrderModel(
            id: "",
            status: .active,
            deliveryDate: nil,
            address: OrderAddressModel(
                coordinates: [],
                addressLine: "Новая Басманная ул., 35",
                floor: "32",
                entrance: "1",
                intercomCode: "4",
                comment: "Лифт не работает, извините("
            ),
            orderPrice: 12,
            deliveryPrice: 12,
            totalPrice: 12,
            totalItems: 12,
            items: [
                OrderItemModel(
                    id: "",
                    image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                    name: "Эчпочмак",
                    weight: 80,
                    price: 120,
                    quantity: 1
                )
            ]
        )
    )
}
