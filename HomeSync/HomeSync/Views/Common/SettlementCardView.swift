//
//  SettlementCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 10.06.2025.
//

import SwiftUI
import FirebaseAuth

struct SettlementCardView: View {
    @Binding var users: [HomeUser]
    var expenses: [[String: Any]]
    var onViewDetailsPressed: () -> Void

    private let maxVisibleUsers = 3

    private var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    private var totalYouOwe: Double {
        expenses
            .filter { ($0["paidBy"] as? String) != currentUserId }
            .compactMap { $0["splitPrice"] as? Double }
            .reduce(0, +)
    }

    private var totalYouAreOwed: Double {
        expenses
            .filter { ($0["paidBy"] as? String) == currentUserId }
            .compactMap { $0["splitPrice"] as? Double }
            .reduce(0, +)
    }

    private var balance: Double {
        totalYouAreOwed - totalYouOwe
    }

    private var balanceLabel: String {
        balance >= 0 ? .youOwned : .youOwe
    }

    private var balanceColor: Color {
        balance >= 0 ? .green : .red
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.appPurple)
                .frame(height: 180)

            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    HStack(spacing: -10) {
                        ForEach(users.prefix(maxVisibleUsers)) { user in
                            GenericTextView(
                                text: userInitials(from: user.fullName),
                                font: Fonts.medium.ofSize(20),
                                textColor: .white
                            )
                            .frame(width: 50, height: 50)
                            .background(.appMediumDark)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.7), lineWidth: 1))
                        }

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
                        GenericTextView(text: balanceLabel, font: Fonts.regular.ofSize(16), textColor: .white)
                        GenericTextView(
                            text: "\(String(format: "%.2f", abs(balance))) RON",
                            font: Fonts.medium.ofSize(24),
                            textColor: .white
                        )
                    }

                    Spacer()
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
