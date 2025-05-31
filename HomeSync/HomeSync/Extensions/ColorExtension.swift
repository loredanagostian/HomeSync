//
//  ColorExtension.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
    
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
}

struct ColorPreset {
    let color: Color
    let hex: String

    static let colors: [ColorPreset] = [
        .init(color: .red, hex: "#E74C3C"),
        .init(color: .green, hex: "#2ECC71"),
        .init(color: .blue, hex: "#3498DB"),
        .init(color: .purple, hex: "#9B59B6"),
        .init(color: .yellow, hex: "#F1C40F"),
        .init(color: .orange, hex: "#E67E22"),
        .init(color: .teal, hex: "#1ABC9C"),
        .init(color: .gray, hex: "#7F8C8D")
    ]
}

