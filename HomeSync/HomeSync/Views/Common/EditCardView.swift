//
//  EditCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 21.05.2025.
//

import SwiftUI

struct EditCardSheet: View {
    var cardNumber: String
    var storeName: String

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            InfoTile(label: "Card number", value: cardNumber)
            InfoTile(label: "Store name", value: storeName)

            Spacer()
        }
        .padding()
        .background(Color(red: 10/255, green: 13/255, blue: 18/255))
    }
}

struct InfoTile: View {
    var label: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GenericTextView(text: label, font: Fonts.regular.ofSize(14), textColor: .white.opacity(0.8))
            
            GenericTextView(text: value, font: Fonts.regular.ofSize(16), textColor: .white)
                .padding(.vertical, 20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 10/255, green: 13/255, blue: 18/255))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.appMediumDark, lineWidth: 1)
                )
        }
        .padding(.vertical)
        .padding(.horizontal, 10)
    }
}
