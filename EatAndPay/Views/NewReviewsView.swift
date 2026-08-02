//
//  NewReviewsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 27.07.2026.
//

import SwiftUI
import DesignSystem
import PhotosUI

struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "video-\(UUID()).mov")
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}

struct NewReviewsView: View {

    private var viewModel: ProductCardViewModel
    private let onSuccess: () -> Void
    @State private var text: String = ""
    @State private var selectedRating: Int = 0
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedVideos: [URL] = []

    @Environment(\.dismiss) private var dismiss

    init(
        viewModel: ProductCardViewModel,
        onSuccess: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.onSuccess = onSuccess
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Отзыв о товаре")
                    .font(DSTypography.hugeTitle)
                    .padding(.top, 12)
                    .padding(.leading, 12)
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
                    HStack(alignment: .top, spacing: 8) {
                        Text(viewModel.productCard?.name ?? "")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("\(viewModel.productCard?.weight.formatted() ?? "") г")
                            .foregroundStyle(DSColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(viewModel.productCard?.description ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Text("Оценка")
                .font(DSTypography.searchTitle)
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        selectedRating = star
                    } label: {
                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(star <= selectedRating ? .black : DSColors.textSecondary)
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
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 5,
                    matching: .images
                ) {
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundStyle(DSColors.plusPinky)
                        .frame(width: 75, height: 75)
                        .background(DSColors.smoky)
                        .cornerRadius(12)
                }

                Text("5 файлов JPG, PNG, BMP, GIF. \nдо 10 МБ каждый")
                    .foregroundStyle(DSColors.textSecondary)
            }
            HStack {
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 1,
                    matching: .videos
                ) {
                    Image(systemName: "video")
                        .font(.system(size: 32))
                        .foregroundStyle(DSColors.plusPinky)
                        .frame(width: 75, height: 75)
                        .background(DSColors.smoky)
                        .cornerRadius(12)
                }
                Text("Видео в формате MOV, MP4. \nдо 300 МБ")
                    .foregroundStyle(DSColors.textSecondary)
            }
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            Spacer()
            Text("Соглашаюсь с правилами публикации")
            DSButton(
                action: {
                    Task {
                        await viewModel.addReview(
                            id: viewModel.productCard?.id ?? "",
                            rating: selectedRating,
                            content: text
                        )
                        onSuccess()
                        dismiss()
                    }
                },
                buttonTitle: "Оставить отзыв"
            )
        }
        .padding(.horizontal, 12)
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                selectedImages.removeAll()
                selectedVideos.removeAll()

                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }

                    if let url = try? await item.loadTransferable(type: Movie.self)?.url {
                        selectedVideos.append(url)
                    }
                }
            }
        }
    }
}

#Preview {
    NewReviewsView(viewModel: ProductCardViewModel(networkService: NetworkServicesImpl()))
}
