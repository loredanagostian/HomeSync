//
//  Fonts.swift
//  HomeSync
//
//  Created by Loredana Gostian on 13.05.2025.
//

import Foundation
import SwiftUI

enum Fonts: String {
    case black = "Axiforma-Black"
    case bold = "Axiforma-Bold"
    case extraBold = "Axiforma-ExtraBold"
    case heavy = "Axiforma-Heavy"
    case light = "Axiforma-Light"
    case medium = "Axiforma-Medium"
    case regular = "Axiforma-Regular"
    case semiBold = "Axiforma-Semibold"
    case thin = "Axiforma-Thin"
    
    func ofSize(_ size: CGFloat) -> Font {
        switch self {
        case .black:
            return .custom(Fonts.black.rawValue, size: size)
        case .bold:
            return .custom(Fonts.bold.rawValue, size: size)
        case .extraBold:
            return .custom(Fonts.extraBold.rawValue, size: size)
        case .heavy:
            return .custom(Fonts.heavy.rawValue, size: size)
        case .light:
            return .custom(Fonts.light.rawValue, size: size)
        case .medium:
            return .custom(Fonts.medium.rawValue, size: size)
        case .regular:
            return .custom(Fonts.regular.rawValue, size: size)
        case .semiBold:
            return .custom(Fonts.semiBold.rawValue, size: size)
        case .thin:
            return .custom(Fonts.thin.rawValue, size: size)
        }
    }
}
