//
//  CachedAsyncImage.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 15.08.2026.
//

import SwiftUI
import DesignSystem

struct CachedAsyncImage<Content: View, Placeholder: View>: View {

    let urlString: String

    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
            }
        }
        .task(id: urlString) {
            guard !urlString.isEmpty else { return }
            isLoading = true
            image = await ImageLoader.shared.loadImage(from: urlString)
            isLoading = false
        }
    }
}
