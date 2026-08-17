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

    /// PostScript-имена кастомных шрифтов Inter
    private static let interRegular = "Inter-Regular"
    private static let interMedium = "Inter-Medium"
    private static let interSemiBold = "Inter-SemiBold"
    private static let interBold = "Inter-Bold"

    /// Имя кастомного шрифта ALS Hauss VF
    private static let alsHaussFamilyName = "ALSHaussVF-Light"

    // MARK: - Headlines

    /// Название продукта в карточке товара
    /// Inter Bold, 14px, line-height 17px
    public static let cardTitle: Font = .custom(interBold, size: 14)

    public static let cardDetailsTitle: Font = .custom(interBold, size: 26)

    public static let hugeTitle: Font = .custom(interBold, size: 32)

    public static let authorReviewTitle: Font = .custom(interMedium, size: 14)
    public static let dateReviewTitle: Font = .custom(interMedium, size: 14)

    /// Большая оценка (например, рейтинг товара)
    /// ALS Hauss VF Light, 94px, letter-spacing -4%
    public static let estimationHuge: Font = .custom(alsHaussFamilyName, size: 94)

    public static let descriptionTitle: Font = .custom(interBold, size: 20)

    public static let searchTitle: Font = .custom(interBold, size: 18)

    public static let reviewSuccessTitle: Font = .custom(alsHaussFamilyName, size: 56)
    public static let reviewSuccessSubtitle: Font = .custom(alsHaussFamilyName, size: 22)

    public static let addressTitle: Font = .custom(interBold, size: 17)
    public static let addressMapTitle: Font = .custom(interBold, size: 24)

    // MARK: - Body

    /// Второстепенный текст (вес)
    public static let caption: Font = .custom(interRegular, size: 14)

    /// Названия вкладок в tabBae
    public static let tabBarTitle: Font = .custom(interBold, size: 18)
}
