//
//  OrderDetailsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 16.08.2026.
//

import SwiftUI
import DesignSystem

struct OrdersView: View {

    @Environment(\.dismiss) private var dismiss

    let orderViewModel: OrderViewModel
    @State private var selectedOrder: OrderModel?

    var attributedText: AttributedString {
        var result = AttributedString("Анастасия\n")
        result.font = DSTypography.authorReviewTitle

        var subtitle = AttributedString("+7 908 305-80-34")
        subtitle.font = DSTypography.caption

        result.append(subtitle)
        return result
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Circle()
                        .fill(DSColors.lightGradient)
                        .frame(width: 40, height: 40)
                        .padding(.leading, 12)
                        .overlay(
                            Text("А")
                                .font(DSTypography.authorReviewTitle)
                                .padding(.leading, 12)
                        )
                    Text(attributedText)
                    Image(.chevronRight)
                        .padding(.top, 16.5)
                }
                .padding(.top, 12)
                Spacer()
                CloseButton(action: { dismiss() })
                    .padding(.trailing, 12)
                    .padding(.top, 12)
            }
            ScrollView {
                ForEach(orderViewModel.orders) { order in
                    if order.status == .active {
                        Button {
                            selectedOrder = order
                        } label: {
                            ActiveOrderView(
                                orders: order.items,
                                addressLine: order.address.addressLine
                            )
                            .padding(.horizontal, 12)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Spacer()
        }
        .sheet(item: $selectedOrder) { order in
            OrderDetailView(orderModel: order)
        }
        .task {
            await orderViewModel.loadOrders()
        }
    }
}

#Preview {
    OrdersView(
        orderViewModel: OrderViewModel(networkService: NetworkServicesImpl())
    )
}
