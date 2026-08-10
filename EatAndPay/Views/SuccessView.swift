//
//  SuccessView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 02.08.2026.
//

import SwiftUI
import DesignSystem

struct SuccessView: View {

    @Environment(\.dismiss) private var dismiss

    let title: String
    let subtitle: String
    let action: () -> Void

    init(
        title: String = "Отзыв отправлен",
        subtitle: String = "Спасибо!\nСкоро мы его опубликуем",
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

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
                Text(title)
                    .font(DSTypography.reviewSuccessTitle)
                    .foregroundStyle(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                Text(subtitle)
                    .font(DSTypography.reviewSuccessSubtitle)
                    .foregroundStyle(DSColors.reviewSuccessSubtitle)
                DSButton(
                    action: {
                        action()
                        dismiss()
                    },
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
    SuccessView()
}
