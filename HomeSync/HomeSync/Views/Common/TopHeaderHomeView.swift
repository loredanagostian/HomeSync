//
//  TopHeaderHomeView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TopHeaderHomeView: View {
    @Binding var isDropdownVisible: Bool

    var userName: String
    var homeName: String
    var selectedHomeCallback: (HomeEntry) -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Spacer()
                    GenericTextView(text: homeName, font: Fonts.bold.ofSize(18), textColor: .white)
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isDropdownVisible ? 180 : 0))
                        .foregroundColor(.white)
                    Spacer()
                }
            }

            HStack {
                GenericTextView(text: userInitials(from: userName), font: Fonts.medium.ofSize(20), textColor: .white)
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
