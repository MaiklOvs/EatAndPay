//
//  DSColors.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI

/// Цветовая палитра дизайн-системы
public enum DSColors {

    // MARK: - Accent

    /// Основной акцентный цвет кнопки добавления в корзину
    public static let accentPinky = Color(
        red: 254 / 255,
        green: 241 / 255,
        blue: 251 / 255,
        opacity: 1
    )

    /// Основной акцентный цвет кнопки количества товара в корзине
    public static let smoky = Color(
        red: 246 / 255,
        green: 246 / 255,
        blue: 250 / 255,
        opacity: 1
    )

    // MARK: - Gradient

    /// Градиент кнопки добавления в корзину
    public static let accentGradient = LinearGradient(
        stops: [
            .init(color: Color(red: 0.93, green: 0.24, blue: 0.79), location: 0.0049),  // #ED3CCA at 0.49%
            .init(color: Color(red: 0.87, green: 0.20, blue: 0.82), location: 0.1488),   // #DF34D2 at 14.88%
            .init(color: Color(red: 0.82, green: 0.17, blue: 0.85), location: 0.2927),   // #D02BD9 at 29.27%
            .init(color: Color(red: 0.75, green: 0.13, blue: 0.88), location: 0.4314),   // #BF22E1 at 43.14%
            .init(color: Color(red: 0.68, green: 0.10, blue: 0.91), location: 0.5702),   // #AE1AE8 at 57.02%
            .init(color: Color(red: 0.60, green: 0.06, blue: 0.94), location: 0.7089),   // #9A10F0 at 70.89%
            .init(color: Color(red: 0.51, green: 0.02, blue: 0.97), location: 0.8476),   // #8306F7 at 84.76%
            .init(color: Color(red: 0.40, green: 0.00, blue: 1.00), location: 0.9915),   // #6600FF at 99.15%
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Text

    /// Основной текст
    public static let textPrimary = Color(
        red: 0.13,
        green: 0.13,
        blue: 0.13
    )

    /// Второстепенный текст
    public static let textSecondary = Color(
        red: 151 / 255,
        green: 151 / 255,
        blue: 175 / 255
    )

    // MARK: - Background

    /// Фон карточки
    public static let cardBackground = Color(
        red: 0.97,
        green: 0.97,
        blue: 0.97
    )

    /// Основной фон экрана
    public static let screenBackground = Color.white

    /// Кнопка добавления в корзину
    public static let plusPinky = Color(
        red: 191 / 255,
        green: 34 / 255,
        blue: 225 / 255
    )

    // MARK: - Favorite

    /// Цвет иконки избранного (активный)
    public static let favoriteActive = Color.red

    /// Цвет иконки избранного (неактивный)
    public static let favoriteInactive = Color(
        red: 0.75,
        green: 0.75,
        blue: 0.75
    )

    // MARK: - Discount

    /// Цвет скидки
    public static let discount = Color.red
}
