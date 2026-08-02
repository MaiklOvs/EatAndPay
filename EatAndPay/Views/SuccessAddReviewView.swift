//
//  SuccessAddReviewView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 02.08.2026.
//

import SwiftUI
import DesignSystem

struct SuccessAddReviewView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            DSColors.accentGradient
                .ignoresSafeArea()
            CloseButton(action: { dismiss() }, color: .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 12)
                .padding(.trailing, 12)
            VStack(alignment: .leading) {
                Spacer()
                Image(.approve)
                Text("Отзыв отправлен")
                    .font(DSTypography.reviewSuccessTitle)
                    .foregroundStyle(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                Text("Спасибо! Скоро мы его опубликуем")
                    .font(DSTypography.reviewSuccessSubtitle)
                    .foregroundStyle(DSColors.reviewSuccessSubtitle)
                DSButton(
                    action: { dismiss() },
                    buttonTitle: "Закрыть",
                    style: .white
                )
                .padding(.bottom, 12)
                .padding(.top, 20)
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    SuccessAddReviewView()
}
