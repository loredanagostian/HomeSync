//
//  FidelityCardsScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 20.05.2025.
//

import SwiftUI
import FirebaseFirestore

struct FidelityCardsScreen: View {
    @Binding var segue: Segues
    @Binding var barcodeString: String
    @Binding var homeId: String
    @Binding var fidelityCard: FidelityCardItem
    @Binding var navigateToHome: Bool
    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var cards: [FidelityCardItem] = []

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .fidelityCards,
                          icons: [
                            IconButton(iconName: "creditcard.viewfinder", iconAction: { showScanner = true })
                          ],
                          backAction: goBack)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(cards) { card in
                        GenericTextView(text: card.storeName, font: Fonts.medium.ofSize(16), textColor: .white)
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color(hex:card.backgroundColorHex))
                            .cornerRadius(12)
                            .onTapGesture {
                                fidelityCard = card
                                navigateToHome = false
                                segue = .fidelityCardSegue
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showScanner) {
            BarcodeScannerWrapper { code in
                scannedCode = code
                showScanner = false
                
                if !code.isEmpty {
                    barcodeString = code
                    segue = .addNewFidelityCardSegue
                }
            }
        }
        .onAppear(perform: loadFidelityCards)
    }
    
    private func goBack() {
        segue = .homeSegue
    }
    
    private func loadFidelityCards() {
        let db = Firestore.firestore()

        db.collection("homes")
          .document(homeId)
          .getDocument { snapshot, error in
              if let error = error {
                  print("Error loading sharedCards: \(error.localizedDescription)")
                  return
              }

              guard let data = snapshot?.data(),
                    let sharedCards = data["sharedCards"] as? [[String: Any]] else {
                  print("No cards found or invalid format.")
                  return
              }

              DispatchQueue.main.async {
                  self.cards = sharedCards.map {
                      FidelityCardItem(
                        backgroundColorHex: $0["colorHex"] as? String ?? "#FFFFFF",
                        cardNumber: $0["cardNumber"] as? String ?? "Unknown",
                        storeName: $0["storeName"] as? String ?? "Unknown"
                      )
                  }
              }
          }
    }
}
