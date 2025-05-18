//
//  GenericTextView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct GenericTextView: View {
    var text: String
    var font: Font
    var textColor: Color
    var textAlignment: TextAlignment = .leading
    var backgroundColor: Color = .clear
    var addUnderline = false
    var body: some View {
        Text(text)
            .modifier(GenericText(font: font,
                                  textColor: textColor,
                                  textAlignment: textAlignment,
                                  backgroundColor: backgroundColor))
    }
}

struct GenericText: ViewModifier {
    var font: Font
    var textColor: Color
    var textAlignment: TextAlignment = .leading
    var backgroundColor: Color = .clear
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
            .multilineTextAlignment(textAlignment)
            .background(backgroundColor)
    }
}
