//
//  HomeScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct HomeScreen: View {
    @Binding var segue: Segues
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 30) {
                    TopHeaderHomeView()
                    initFidelityCardsSection()
//                    YourListsView()
//                    PinnedPhotosView()
//                    UpcomingBillsView()
//                    SettlementCardView()
                }
            }
            .padding(.top, 60)

            GenericTabBar(selectedTab: .home)
            .padding(.bottom, 50)
        }
        .background(.appDark)
        .ignoresSafeArea(edges: .bottom)
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
}
