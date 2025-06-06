//
//  HomeMemberRow.swift
//  HomeSync
//
//  Created by Loredana Gostian on 06.06.2025.
//

import SwiftUI

struct HomeMemberRow: View {
    let member: HomeUser
    let buttonVisible: Bool
    let isRemove: Bool
    let onPress: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            GenericTextView(
                text: userInitials(from: member.fullName),
                font: Fonts.medium.ofSize(20),
                textColor: .white
            )
            .frame(width: 50, height: 50)
            .background(.appPurple)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(member.fullName)
                    .fontWeight(.semibold)
                Text(member.email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if buttonVisible {
                Button(action: onPress) {
                    GenericTextView(text: isRemove ? "Remove" : "Add", font: Fonts.semiBold.ofSize(14), textColor: .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
