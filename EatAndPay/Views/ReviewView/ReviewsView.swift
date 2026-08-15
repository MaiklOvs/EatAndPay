//
//  ReviewsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 28.07.2026.
//

import SwiftUI
import DesignSystem

struct ReviewsView: View {

    @Bindable private var productService: ProductService
    @State private var isReviewsPresented = false
    @State private var isSuccessPresented = false
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
            let result = dateFormatter.string(from: date)
            print("✅ ISO success: \(result)") // 👈 Добавьте
            return result
        }

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = inputFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }

        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = fallbackFormatter.date(from: dateString) {
            let result = dateFormatter.string(from: date)
            print("✅ Fallback success: \(result)") // 👈 Добавьте
            return result
        }
        print("❌ Failed: returning original \(dateString)")
        return dateString
    }

    private var reviews: [Review] {
        productService.productCard?.reviews ?? []
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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "star.fill")
                        .foregroundStyle(star <= review.rating ? .black : DSColors.textSecondary)
                        .font(.system(size: 12))
                }
                Text("\(review.author),")
                    .font(DSTypography.authorReviewTitle)
                    .foregroundStyle(DSColors.textPrimary)
                    .padding(.leading, 6)
                Text(formattedDate(review.createdAt))
                    .font(DSTypography.dateReviewTitle)
                    .foregroundStyle(DSColors.textPrimary)
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
        productService: ProductService
    ) {
        self.productService = productService
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
            HStack(alignment: .top, spacing: 0) {
                Text(String(format: "%.1f", productService.productCard?.rating ?? 0))
                    .font(DSTypography.estimationHuge)
                    .frame(width: 135, alignment: .trailing)
                    .padding(.trailing, 8)
                    .padding(.leading, 12)
                VStack(spacing: 1) {
                    ForEach(Array(stride(from: 5, through: 1, by: -1)), id: \.self) { rating in
                        HStack(spacing: 2) {
                            Text(String(repeating: "★", count: rating))
                                .foregroundStyle(rating >= 4 ? .black : DSColors.textSecondary)
                                .frame(width: 95, alignment: .trailing)
                                .padding(.trailing, 2)
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
                                .frame(width: 30, alignment: .trailing)
                                .foregroundStyle(count(for: rating) == 0 ? DSColors.textSecondary : DSColors.textPrimary )
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            DSButton(
                action: { isReviewsPresented = true },
                buttonTitle: "Написать отзыв",
                style: .light
            )
                .padding(.horizontal, 12)
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(reviews) { review in
                        reviewCell(review)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 24)
            }
        }
        .sheet(isPresented: $isReviewsPresented) {
            NewReviewsView(
                productService: productService,
                onSuccess: {
                    isReviewsPresented = false
                    isSuccessPresented = true
                }
            )
        }
        .fullScreenCover(isPresented: $isSuccessPresented) {
            SuccessView()
        }
    }
}

#Preview {
    ReviewsView(
        productService: ProductService(networkService: NetworkServicesImpl())
    )
}
