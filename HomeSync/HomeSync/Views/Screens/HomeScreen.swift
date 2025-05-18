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
                VStack(spacing: 24) {
                    TopHeaderView()
                    FidelityCardsView(cards: [
                        (logo: Image("card_logo1"), barcode: Image("barcode1")),
                        (logo: Image("card_logo2"), barcode: Image("barcode2")),
                        (logo: Image("card_logo3"), barcode: Image("barcode3"))
                    ])

//                    YourListsView()
//                    PinnedPhotosView()
//                    UpcomingBillsView()
//                    SettlementCardView()
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding(.top, 60)

            GenericTabBar(selectedTab: .home)
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(Color("appDark"))
        .ignoresSafeArea(edges: .bottom)
    }
}
