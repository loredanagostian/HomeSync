//
//  FidelityCardsView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct FidelityCardsView: View {
    let cards: [(logo: Image, barcode: Image)]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<cards.count, id: \.self) { index in
                    FidelityCardView(cardImage: cards[index].logo,
                                     barcodeImage: cards[index].barcode)
                }
            }
            .padding(.horizontal)
        }
    }
}
