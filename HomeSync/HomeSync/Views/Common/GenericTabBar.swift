//
//  GenericTabBar.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct GenericTabBar: View {
    var selectedTab: Tab

    var body: some View {
        HStack {
            Spacer()
            tabItem(icon: "arrow.left.arrow.right", label: .split, isSelected: selectedTab == .split)
            Spacer()
            tabItem(icon: "house", label: .home, isSelected: selectedTab == .home, color: .appPurple)
            Spacer()
            tabItem(icon: "ellipsis", label: .more, isSelected: selectedTab == .more)
            Spacer()
        }
        .padding()
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(hex: "#D9D9D9").opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#121212").opacity(0.1),
                                    Color(hex: "#121212").opacity(0.5)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    func tabItem(icon: String, label: String, isSelected: Bool, color: Color = .white) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(Fonts.regular.ofSize(16))
                .frame(height: 20)

            Text(label)
                .font(isSelected ? Fonts.bold.ofSize(12) : Fonts.regular.ofSize(12))
                .frame(height: 14)
        }
        .foregroundColor(color.opacity(isSelected ? 1 : 0.7))
        .frame(maxWidth: .infinity)
    }
}
