//
//  FidelityCardsScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 20.05.2025.
//

import SwiftUI

struct FidelityCardItem: Identifiable {
    let id = UUID()
    let title: String
    let backgroundColor: Color
}

struct FidelityCardsScreen: View {
    @Binding var segue: Segues
    
    // Sample data
    let cards: [FidelityCardItem] = [
        .init(title: "Auchan", backgroundColor: .red),
        .init(title: "Dr. Max", backgroundColor: .green),
        .init(title: "SensiBlu", backgroundColor: .blue),
        .init(title: "Carturesti", backgroundColor: .green),
        .init(title: "Decathlon", backgroundColor: .purple),
        .init(title: "Selgros", backgroundColor: .yellow),
        .init(title: "OMV", backgroundColor: .green),
        .init(title: "Carrefour", backgroundColor: .blue),
        .init(title: "Profi", backgroundColor: .red),
        .init(title: "Farmado", backgroundColor: .green),
        .init(title: "Punkt", backgroundColor: .purple),
        .init(title: "Kaufland", backgroundColor: .red)
    ]
    
    // Grid layout
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .fidelityCards,
                          icons: [
                            IconButton(iconName: "square.grid.2x2", iconAction: { print("Grid tapped") }),
                            IconButton(iconName: "creditcard.viewfinder", iconAction: { print("Card tapped") })
                          ],
                          backAction: goBack)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(cards) { card in
                        GenericTextView(text: card.title, font: Fonts.medium.ofSize(16), textColor: .white)
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(card.backgroundColor)
                            .cornerRadius(12)
                            .onTapGesture {
                                segue = .fidelityCardSegue
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private func goBack() {
        segue = .homeSegue
    }
}
