//
//  GenericActionTile.swift
//  HomeSync
//
//  Created by Loredana Gostian on 21.05.2025.
//

import SwiftUI

struct GenericActionTile: View {
    let iconName: String
    let title: String
    let action: () -> Void
    let isArrowVisible: Bool
    let color: Color
    
    init(iconName: String, title: String, isArrowVisible: Bool = true, color: Color = .white, action: @escaping () -> Void) {
        self.iconName = iconName
        self.title = title
        self.isArrowVisible = isArrowVisible
        self.action = action
        self.color = color
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 24)

                GenericTextView(text: title, font: Fonts.regular.ofSize(14), textColor: color)
                    .padding(.leading, 4)

                Spacer()

                if isArrowVisible {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .background(.appMediumDark)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
