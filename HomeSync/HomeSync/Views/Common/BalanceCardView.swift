//
//  BalanceCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 11.06.2025.
//

import SwiftUI

struct BalanceCardView: View {
    var amountOwedToYou: Double
    var amountYouOwe: Double
    
    private var balance: Double {
       amountOwedToYou - amountYouOwe
    }

    private var balanceText: String {
       balance >= 0 ? .youOwned : .youOwe
    }

    private var balanceColor: Color {
       balance >= 0 ? .green : .red
    }

    var body: some View {
        VStack(spacing: 16) {
            GenericTextView(text: .yourBalance, font: Fonts.medium.ofSize(18), textColor: .white)
            
            GenericTextView(text: "\(String(format: "%.2f", balance)) LEI", font: Fonts.bold.ofSize(24), textColor: balanceColor)

            GenericTextView(text: balanceText, font: Fonts.medium.ofSize(14), textColor: .appBlack)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
            
            HStack {
                VStack {
                    Label(String.youGetBack, systemImage: "arrow.down.left")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    GenericTextView(text: "\(String(format: "%.2f", amountOwedToYou)) LEI", font: Fonts.medium.ofSize(18), textColor: .green)
                }
                Spacer()
                VStack {
                    Label(String.youOwe, systemImage: "arrow.up.right")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    GenericTextView(text: "\(String(format: "%.2f", amountYouOwe)) LEI", font: Fonts.medium.ofSize(18), textColor: .red)
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
        BalanceCardView(amountOwedToYou: 0, amountYouOwe: 0)
    }
}
