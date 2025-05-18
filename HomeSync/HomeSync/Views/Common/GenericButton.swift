//
//  GenericButton.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct GenericButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.appPurple)
                    .frame(height: 60)

                Text(title)
                    .font(Fonts.bold.ofSize(16))
                    .foregroundColor(.white)

                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
                .frame(height: 60)
            }
        }
        .frame(width: 350)
    }
}
