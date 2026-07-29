//
//  ReviewsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 28.07.2026.
//

import SwiftUI
import DesignSystem

struct ReviewsView: View {

    private var viewModel: ProductCardViewModel
    @State private var isReviewsPresented = false
    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    private func formattedDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }

        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = fallbackFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }

        return dateString
    }

    private var reviews: [Review] {
        viewModel.productCard?.reviews ?? []
    }

    private var totalReviews: Int {
        reviews.count
    }

    private func count(for rating: Int) -> Int {
        reviews.filter { $0.rating == rating }.count
    }

    private func fillRatio(for rating: Int) -> Double {
        guard totalReviews > 0 else { return 0 }
        return Double(count(for: rating)) / Double(totalReviews)
    }

    private func reviewCell(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                        .foregroundStyle(star <= review.rating ? .black : DSColors.textSecondary)
                        .font(.system(size: 12))
                }
                Spacer()
            }

            HStack {
                Text(review.author)
                    .font(DSTypography.searchTitle)
                    .foregroundStyle(DSColors.textPrimary)
                Text(formattedDate(review.createdAt))
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary)
                Spacer()
            }

            Text(review.content)
                .font(DSTypography.cardTitle)
                .foregroundStyle(DSColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(DSColors.smoky)
        .cornerRadius(12)
    }


    init(
        viewModel: ProductCardViewModel
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Отзывы")
                    .font(DSTypography.hugeTitle)
                    .padding(.top, 12)
                    .padding(.leading, 12)
                Text("\(totalReviews)")
                    .font(DSTypography.hugeTitle)
                    .foregroundStyle(DSColors.textSecondary)
                    .padding(.top, 12)
                Spacer()
                CloseButton(action: { dismiss() } )
                    .padding(.trailing, 12)
            }
            HStack() {
                Text(String(format: "%.1f", viewModel.productCard?.rating ?? 0))
                    .font(DSTypography.estimationHuge)
                    .padding(.leading, 12)
                VStack(spacing: 4) {
                    ForEach(Array(stride(from: 5, through: 1, by: -1)), id: \.self) { rating in
                        HStack {
                            Text(String(repeating: "★", count: rating))
                                .foregroundStyle(rating >= 4 ? .black : DSColors.textSecondary)
                                .frame(width: 95, alignment: .trailing)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(DSColors.smoky)
                                        .frame(height: 1)
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(DSColors.textPrimary)
                                        .frame(width: geo.size.width * fillRatio(for: rating), height: 1)
                                }
                            }
                            .frame(width: 100, height: 1)
                            Text("\(count(for: rating))")
                                .frame(width: 20, alignment: .trailing)
                                .foregroundStyle(DSColors.textPrimary)
                        }
                    }
                }
            }
            DSButton(
                action: { isReviewsPresented = true },
                buttonTitle: "Написать отзыв",
                style: .light
            )
                .padding(.horizontal, 12)
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(reviews) { review in
                        reviewCell(review)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
        }
        .sheet(isPresented: $isReviewsPresented) {
            NewReviewsView(viewModel: viewModel)
        }
    }
}

#Preview {
    ReviewsView(
        viewModel: ProductCardViewModel(networkService: NetworkServicesImpl())
    )
}
