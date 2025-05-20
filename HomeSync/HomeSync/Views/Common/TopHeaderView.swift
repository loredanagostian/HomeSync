//
//  TopHeaderView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct TopHeaderView: View {
    var userName = "Lore Gostian"
    var homeName = "HomeName"

    var body: some View {
        ZStack {
            // Centered home name
            HStack(spacing: 4) {
                Spacer()
                GenericTextView(text: homeName, font: Fonts.bold.ofSize(18), textColor: .white)
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                Spacer()
            }

            HStack {
                Text(userInitials(from: userName))
                    .font(Fonts.medium.ofSize(20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(.appPurple)
                    .clipShape(Circle())

                Spacer()

                HStack(spacing: 12) {
                    CircularIconButton(systemIconName: "square.grid.2x2") {}
                    CircularIconButton(systemIconName: "bell.badge") {}
                }
            }
        }
        .padding(.horizontal)
    }

    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
