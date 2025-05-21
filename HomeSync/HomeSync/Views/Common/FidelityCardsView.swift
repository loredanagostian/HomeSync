//
//  FidelityCardsView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct FidelityCardsView: View {
    let cards: [(logo: Image, barcode: Image)]
    @State private var currentIndex: Int = 1
    @GestureState private var dragOffset: CGFloat = 0

    var limitedCards: [(logo: Image, barcode: Image)] {
        Array(cards.prefix(5))
    }

    let cardWidth: CGFloat = 260
    let spacing: CGFloat = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { outerProxy in
                let totalCardWidth = cardWidth + spacing
                
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(limitedCards.enumerated()), id: \.offset) { index, card in
                                GeometryReader { geo in
                                    let midX = geo.frame(in: .global).midX
                                    let screenMidX = outerProxy.frame(in: .global).midX
                                    let distance = abs(midX - screenMidX)
                                    let scale = max(0.85, 1 - (distance / screenMidX) * 0.2)

                                    FidelityCardView(
                                        title: "Auchan",
                                        headerColor: .red,
                                        barcodeText: "A4583B14",
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
                                    if offset > threshold, currentIndex < limitedCards.count - 1 {
                                        currentIndex += 1
                                    } else if offset < -threshold, currentIndex > 0 {
                                        currentIndex -= 1
                                    }

                                    withAnimation(.easeOut(duration: 0.35)) {
                                        scrollProxy.scrollTo(currentIndex, anchor: .center)
                                    }
                                }
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scrollProxy.scrollTo(currentIndex, anchor: .center)
                            }
                        }
                    }
                }
            }
            .frame(height: 180)
        }
    }
}
