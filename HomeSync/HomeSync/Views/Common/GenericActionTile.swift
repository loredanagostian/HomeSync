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

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 24)

                GenericTextView(text: title, font: Fonts.regular.ofSize(14), textColor: .white)
                    .padding(.leading, 4)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .background(.appMediumDark)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
