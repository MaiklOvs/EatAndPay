//
//  CatalogCardsView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 02.07.2026.
//

import SwiftUI
import DesignSystem

struct CatalogCardsView: View {

    let catalogCardModel: CatalogCard

    var body: some View {
        AsyncImage(url: URL(string: catalogCardModel.image)) { image in
            image.image?.resizable()
                .overlay() {
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.965, green: 0.965, blue: 0.980), location: 0.0),
                            .init(color: Color(red: 0.965, green: 0.965, blue: 0.980), location: 0.327),
                            .init(color: Color(red: 0.976, green: 0.976, blue: 0.988).opacity(0.643), location: 0.577),
                            .init(color: Color.white.opacity(0), location: 1.0)
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .padding(.top, 48)
                    .background(.ultraThinMaterial.opacity(0.1))
                }
                .overlay(alignment: .bottomLeading) {
                    Text(catalogCardModel.name)
                        .font(DSTypography.cardTitle)
                        .lineSpacing(1)
                        .padding(.top, 48)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 6)
                }
                .frame(width: 115, height: 132)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    CatalogCardsView(catalogCardModel: CatalogCard(id: "1", name: "Фермерские товары", image: ""))
}
