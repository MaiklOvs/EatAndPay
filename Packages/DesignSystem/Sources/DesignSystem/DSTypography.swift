//
//  DSTypography.swift
//  DesignSystem
//
//  Created by Ovsyannikov.M10 on 26.06.2026.
//

import SwiftUI

/// Типографика дизайн-системы
///
/// Шрифт: Inter (Google Fonts)
/// Для подключения добавь шрифт в Assets.xcassets или через SPM-пакет SwiftUI-Introspect.
/// Если шрифт Inter не найден, используется системный .system как fallback.
public enum DSTypography {

    // MARK: - Font Family

    /// Имя кастомного шрифта Inter
    private static let interFamilyName = "Inter"

    // MARK: - Headlines

    /// Название продукта в карточке товара
    /// Inter Regular, 14px, line-height 17px
    public static let cardTitle: Font = .custom(interFamilyName, size: 14).weight(.bold)

    public static let cardDetailsTitle: Font = .custom(interFamilyName, size: 26).weight(.bold)

    public static let hugeTitle: Font = .custom(interFamilyName, size: 32).weight(.bold)

    public static let descriptionTitle: Font = .custom(interFamilyName, size: 20).weight(.bold)

    public static let seatchTitle: Font = .custom(interFamilyName, size: 18).weight(.bold)

    // MARK: - Body

    /// Второстепенный текст (вес)
    public static let caption: Font = .custom(interFamilyName, size: 14)

    /// Названия вкладок в tabBae
    public static let tabBarTitle: Font = .custom(interFamilyName, size: 18)
}
