//
//  NewReviewsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 27.07.2026.
//

import SwiftUI
import DesignSystem

struct NewReviewsView: View {

    @State private var viewModel = ProductCardViewModel(networkService: NetworkServicesImpl())
    @State private var text: String = ""
    @Bindable var cartViewModel: CartViewModel
    let productId: String
    let onFavoriteToggle: () -> Void
    @Environment(\.dismiss) private var dismiss

    init(
        productId: String,
        cartViewModel: CartViewModel,
        onFavoriteToggle: @escaping () -> Void
    ) {
        self.productId = productId
        self.cartViewModel = cartViewModel
        self.onFavoriteToggle = onFavoriteToggle
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Отзыв о товаре")
                    .font(DSTypography.hugeTitle)
                Spacer()
                CloseButton(action: { dismiss() } )
            }
            HStack {
                AsyncImage(url: URL(string: viewModel.productCard?.image ?? "")) { image in
                    image.image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack {
                    HStack {
                        Text(viewModel.productCard?.name ?? "Бутер с колбасой")
                        Text("\(viewModel.productCard?.weight.formatted() ?? "100") г")
                            .foregroundStyle(DSColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text(viewModel.productCard?.description ?? "Белый хлеб")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Text("Оценка")
                .font(DSTypography.searchTitle)
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button {

                    } label: {
                        Image(systemName: "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(DSColors.textSecondary)
                    }
                }
            }
            Text("Комментарий")
                .font(DSTypography.searchTitle)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(height: 75)
                    .padding(12)
                    .background(DSColors.screenBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DSColors.textSecondary.opacity(0.4), lineWidth: 1)
                    )

                if text.isEmpty {
                    Text("Впечатления, пожелания, проблемы с удобными пуфиками, большими зеркалами и плотной шторкой.")
                        .font(DSTypography.caption)
                        .foregroundStyle(DSColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
            HStack {
                Button {
                } label: {
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundStyle(DSColors.plusPinky)
                }
                .frame(width: 75, height: 75)
                .background(DSColors.smoky)
                .cornerRadius(12)
                Text("5 файлов JPG, PNG, BMP, GIF. \nдо 10 МБ каждый")
                    .foregroundStyle(DSColors.textSecondary)
            }
            HStack {
                Button {
                } label: {
                    Image(systemName: "video")
                        .font(.system(size: 32))
                        .foregroundStyle(DSColors.plusPinky)
                }
                .frame(width: 75, height: 75)
                .background(DSColors.smoky)
                .cornerRadius(12)
                Text("Видео в формате MOV, MP4. \nдо 300 МБ")
                    .foregroundStyle(DSColors.textSecondary)
            }
            Spacer()
            Text("Соглашаюсь с правилами публикации")
            AddToCartButton(action: {}, buttonTitle: "Оставить отзыв")
        }
        .padding(.horizontal, 12)
        .task(id: productId) {
            await viewModel.loadProductDetails(id: productId)
        }
    }
}

#Preview {
    NewReviewsView(
        productId: "",
        cartViewModel: CartViewModel(networkService: NetworkServicesImpl()),
        onFavoriteToggle: {  }
    )
}
