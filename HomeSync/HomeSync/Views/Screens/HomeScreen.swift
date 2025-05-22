//
//  HomeScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct HomeEntry: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let members: Int
}

struct HomeScreen: View {
    @Binding var segue: Segues
    @State private var isDropdownVisible = false
    @State private var selectedHome: HomeEntry = HomeEntry(name: "HomeName", members: 3)
    
    let availableHomes = [
        HomeEntry(name: "HomeName", members: 3),
        HomeEntry(name: "Office", members: 5),
        HomeEntry(name: "Parents' House", members: 2),
        HomeEntry(name: "Vacation House", members: 1)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 30) {
                        TopHeaderHomeView(
                            isDropdownVisible: $isDropdownVisible, userName: "Lore Gostian",
                            homeName: selectedHome.name,
                            selectedHomeCallback: { selectedHome = $0 }
                        )

                        self.initFidelityCardsSection() // <== Add self
                    }
                }
                .padding(.top, 60)

                GenericTabBar(selectedTab: .home)
                    .padding(.bottom, 50)
            }
            .background(.appDark)
            .ignoresSafeArea(edges: .bottom)

            if isDropdownVisible {
                DropdownOverlay(
                    homes: availableHomes,
                    selectedHome: $selectedHome,
                    isVisible: $isDropdownVisible
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
                .zIndex(1)
            }
        }
    }

    private func initFidelityCardsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            initSectionView(sectionTitle: .fidelityCards)

            FidelityCardsView(cards: [
                (logo: Image("card_logo1"), barcode: Image("barcode1")),
                (logo: Image("card_logo2"), barcode: Image("barcode2")),
                (logo: Image("card_logo3"), barcode: Image("barcode3"))
            ])
        }
    }

    private func initSectionView(sectionTitle: String) -> some View {
        HStack {
            HStack(alignment: .top, spacing: 15) {
                GenericTextView(text: sectionTitle, font: Fonts.semiBold.ofSize(20), textColor: .white)
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
            }

            Spacer()

            HStack(spacing: 4) {
                GenericTextView(text: .more, font: Fonts.regular.ofSize(16), textColor: .white)
                Image(systemName: "arrow.right.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                segue = .fidelityCardsSegue
            }
        }
        .padding(.horizontal)
    }
}
