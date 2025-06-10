//
//  BalanceCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 11.06.2025.
//

import SwiftUI

struct BalanceCardView: View {
    var balance: Double = 23.75
    var amountOwedToYou: Double = 180.25
    var amountYouOwe: Double = 156.50

    var body: some View {
        VStack(spacing: 16) {
            GenericTextView(text: .yourBalance, font: Fonts.medium.ofSize(18), textColor: .white)
            
            GenericTextView(text: "$\(String(format: "%.2f", balance))", font: Fonts.bold.ofSize(24), textColor: .green)

            GenericTextView(text: balance >= 0 ? .youOwned : .youOwe, font: Fonts.medium.ofSize(14), textColor: .appBlack)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
            
            HStack {
                VStack {
                    Label(String.youGetBack, systemImage: "arrow.down.left")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    GenericTextView(text: "$\(String(format: "%.2f", amountOwedToYou))", font: Fonts.medium.ofSize(18), textColor: .green)
                }
                Spacer()
                VStack {
                    Label(String.youOwe, systemImage: "arrow.up.right")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    GenericTextView(text: "$\(String(format: "%.2f", amountYouOwe))", font: Fonts.medium.ofSize(18), textColor: .red)
                }
            }
        }
        .padding()
        .background(Color.appBlack)
        .cornerRadius(12)
        .padding()
    }
}

struct BalanceCardView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceCardView()
    }
}
