//
//  CompletedOrderView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 24.08.2026.
//

import SwiftUI
import DesignSystem
import SwiftData

struct CompletedOrderView: View {

    let orders: [OrderItemModel]
    let totalPrice: Int
    let totalItems: Int
    let deliveryDate: String

    private let imageSize: CGFloat = 47
    private let overlap: CGFloat = 12
    private let cornerRadius: CGFloat = 8
    private let maxVisibleImages = 9

    func productDeclension(for count: Int) -> String {
        let remainderTen = count % 10
        let remainderHundred = count % 100

        if remainderHundred >= 11 && remainderHundred <= 19 {
            return "товаров"
        }

        switch remainderTen {
        case 1:
            return "товар"
        case 2, 3, 4:
            return "товара"
        default:
            return "товаров"
        }
    }

    var attributedText: AttributedString {
        var totalItemsText = AttributedString("\(totalItems) \(productDeclension(for: totalItems))\n")
        totalItemsText.font = DSTypography.descriptionTitle
        totalItemsText.foregroundColor = .gray

        var result = AttributedString("\(totalPrice) ₽ ")
        result.font = DSTypography.descriptionTitle

        var subtitle = AttributedString("Доставили \(deliveryDate)")
        subtitle.font = DSTypography.caption

        result.append(totalItemsText)
        result.append(subtitle)
        return result
    }

    private var visibleOrders: [OrderItemModel] {
        if orders.count <= maxVisibleImages {
            return orders
        }
        return Array(orders.prefix(maxVisibleImages - 1))
    }

    private var remainingCount: Int {
        orders.count - visibleOrders.count
    }

    private var totalWidth: CGFloat {
        let count = visibleOrders.count
        guard count > 0 else { return 0 }
        return CGFloat(count) * imageSize - CGFloat(max(0, count - 1)) * overlap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(attributedText)
                    .padding(.leading, 12)
                    .padding(.top, 12)
                Spacer()
                Image(.chevronRight)
                    .padding(.trailing, 12)
            }

            HStack(spacing: -overlap) {
                let visibleOrders = visibleOrders
                let remainingCount = remainingCount

                ForEach(Array(visibleOrders.enumerated()), id: \.element.id) { index, order in
                    let isLast = index == visibleOrders.count - 1
                    let showOverlay = isLast && remainingCount > 0

                    productImage(
                        urlString: order.image,
                        showOverlay: showOverlay,
                        overlayText: "+\(remainingCount)"
                    )
                }

                // Добавляем Spacer, чтобы изображения были прижаты к левому краю
                Spacer(minLength: 0)
            }
            .padding(.leading, 12)
            .frame(height: imageSize)
            .padding(.vertical, 16)
        }
        .background(DSColors.smoky)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func productImage(
        urlString: String,
        showOverlay: Bool,
        overlayText: String
    ) -> some View {
        ZStack {
            CachedAsyncImage(
                urlString: urlString,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    DSImagePlaceholder()
                }
            )
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(DSColors.smoky, lineWidth: 2)
            )

            // Затемненный оверлей с количеством
            if showOverlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black.opacity(0.6))
                    .overlay {
                        Text(overlayText)
                            .font(DSTypography.descriptionTitle)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
            }
        }
        .frame(width: imageSize, height: imageSize)
    }
}

#Preview {
    CompletedOrderView(
        orders: (1...12).map { index in
            OrderItemModel(
                id: "\(index)",
                image: "https://eat-and-pay.t02.ru/uploads/eats-jxl/echpochmak.jxl",
                name: "Огурец в тесте",
                weight: 100,
                price: 1000,
                quantity: 1
            )
        },
        totalPrice: 100,
        totalItems: 12,
        deliveryDate: "24 августа в 08:31"
    )
}
