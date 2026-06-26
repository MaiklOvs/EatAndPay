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
