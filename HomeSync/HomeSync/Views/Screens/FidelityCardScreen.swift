//
//  FidelityCardScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 21.05.2025.
//

import SwiftUI

struct FidelityCardScreen: View {
    @Binding var segue: Segues
    @Binding var cardName: String
    @State private var isEditSheetPresented = false
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: cardName, icons: [IconButton(iconName: "trash", iconAction: { print("Trash tapped") })], backAction: goBack)
            VStack {
                FidelityCardView(
                    title: "Auchan",
                    headerColor: .red,
                    barcodeText: "A4583B14",
                    height: 200,
                    width: 330
                )
                
                Spacer()
                    .frame(height: 40)
                
                GenericActionTile(iconName: "pencil", title: "Edit card") {
                    isEditSheetPresented = true
                }
                
                Spacer()
                    .frame(height: 10)
                
                GenericActionTile(iconName: "camera", title: "Photos") {
                    print("Photos tapped")
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EditCardSheet(cardNumber: "12345678901234567890", storeName: "Auchan")
                .presentationDetents([.medium]) // or [.fraction(0.4)] for custom height
                .presentationDragIndicator(.visible)
        }
    }
    
    private func goBack() {
        segue = .fidelityCardsSegue
    }
}
