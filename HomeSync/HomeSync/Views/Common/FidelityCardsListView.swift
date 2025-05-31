//
//  FidelityCardsListView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct FidelityCardsListView: View {
    @Binding var cards: [FidelityCardItem]
    @Binding var fidelityCard: FidelityCardItem
    @Binding var segue: Segues
    @Binding var navigateToHome: Bool
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0

    let cardWidth: CGFloat = 260
    let spacing: CGFloat = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { outerProxy in
                let totalCardWidth = cardWidth + spacing
                
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                                GeometryReader { geo in
                                    let midX = geo.frame(in: .global).midX
                                    let screenMidX = outerProxy.frame(in: .global).midX
                                    let distance = abs(midX - screenMidX)
                                    let scale = max(0.85, 1 - (distance / screenMidX) * 0.2)

                                    FidelityCardView(
                                        title: card.storeName,
                                        headerColor: Color(hex: card.backgroundColorHex),
                                        barcodeText: card.cardNumber,
                                        height: 150,
                                        width: 270
                                    )
                                    .scaleEffect(scale)
                                    .opacity(Double(scale))
                                    .animation(.easeOut(duration: 0.25), value: scale)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.35)) {
                                            currentIndex = index
                                            scrollProxy.scrollTo(index, anchor: .center)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                                self.fidelityCard = card
                                                self.navigateToHome = true
                                                segue = .fidelityCardSegue
                                            }
                                        }
                                    }
                                }
                                .frame(width: cardWidth, height: 150)
                                .id(index)
                            }
                        }
                        .padding(.horizontal, (outerProxy.size.width - cardWidth) / 2)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation.width
                                }
                                .onEnded { value in
                                    let offset = -value.translation.width
                                    let threshold: CGFloat = totalCardWidth / 3
                                    if offset > threshold, currentIndex < cards.count - 1 {
                                        currentIndex += 1
                                    } else if offset < -threshold, currentIndex > 0 {
                                        currentIndex -= 1
                                    }

                                    withAnimation(.easeOut(duration: 0.35)) {
                                        scrollProxy.scrollTo(currentIndex, anchor: .center)
                                    }
                                }
                        )
                    }
                    .onChange(of: cards) { _, newCards in
                       DispatchQueue.main.async {
                            scrollProxy.scrollTo(0, anchor: .center)
                        }
                    }
                }
            }
            .frame(height: 180)
        }
    }
}
