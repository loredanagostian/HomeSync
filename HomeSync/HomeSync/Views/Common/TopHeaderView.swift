//
//  TopHeaderView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct TopHeaderView: View {
    var userName: String = "Lore Gostian"

    var body: some View {
        HStack(alignment: .center) {
            Text(userInitials(from: userName))
                .font(Fonts.medium.ofSize(20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(.appPurple)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("Good evening,")
                    .font(Fonts.light.ofSize(20))
                    .foregroundColor(.white)

                Text(userName.components(separatedBy: " ").first ?? userName)
                    .font(Fonts.medium.ofSize(20))
                    .foregroundColor(.white)
            }

            Spacer()

            HStack(spacing: 12) {
                CircularIconButton(systemIconName: "square.grid.2x2") {
                    // Handle grid/menu action
                }

                CircularIconButton(systemIconName: "bell.badge") {
                    // Handle grid/menu action
                }
            }
        }
        .padding(.horizontal)
    }

    // Helper to extract initials
    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
