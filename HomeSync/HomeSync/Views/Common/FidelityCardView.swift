//
//  FidelityCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct FidelityCardView: View {
    let cardImage: Image
    let barcodeImage: Image

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            cardImage
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 16)
                .padding(.horizontal, 16)

            Spacer()

            barcodeImage
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .frame(width: 200, height: 120)
        .background(Color.appMediumDark)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}
