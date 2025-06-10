//
//  SettlementCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 10.06.2025.
//

import SwiftUI

struct SettlementCardView: View {
    @Binding var users: [HomeUser]
    var onViewDetailsPressed: () -> Void
    
    private let maxVisibleUsers = 3
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.appPurple)
                .frame(height: 180)

            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    HStack(spacing: -10) {
                        // Display initials for the first 'maxVisibleUsers'
                        ForEach(users.prefix(maxVisibleUsers)) { user in
                            GenericTextView(text: userInitials(from: user.fullName), font: Fonts.medium.ofSize(20), textColor: .white)
                                .frame(width: 50, height: 50)
                                .background(.appMediumDark)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white.opacity(0.7), lineWidth: 1))
                        }
                        
                        // If there are more users, display an "+X" circle
                        if users.count > maxVisibleUsers {
                            let remainingUsersCount = users.count - maxVisibleUsers
                            Circle()
                                .fill(.appDark)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    GenericTextView(text: "+\(remainingUsersCount)", font: Fonts.medium.ofSize(20), textColor: .white)
                                )
                                .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        GenericTextView(text: .viewDetails, font: Fonts.regular.ofSize(14), textColor: .white)
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.white)
                    }
                    .onTapGesture(perform: onViewDetailsPressed)
                }
                .padding(.bottom, 30)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        GenericTextView(text: .youOwned, font: Fonts.regular.ofSize(16), textColor: .white)

                        GenericTextView(text: "100 RON", font: Fonts.medium.ofSize(24), textColor: .white)
                    }

                    Spacer()

                    Button(action: {
                        // Action for "Settle up"
                    }) {
                        HStack {
                            GenericTextView(text: .settleUp, font: Fonts.bold.ofSize(16), textColor: .white)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}

struct SettlementCardView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementCardView(users: .constant([]), onViewDetailsPressed: {})
    }
}
