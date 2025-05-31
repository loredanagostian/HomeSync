//
//  FidelityCardScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 21.05.2025.
//

import SwiftUI
import FirebaseFirestore

struct FidelityCardScreen: View {
    @Binding var segue: Segues
    @Binding var fidelityCard: FidelityCardItem
    @Binding var navigateToHome: Bool
    @Binding var homeId: String
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: fidelityCard.storeName, icons: [IconButton(iconName: "trash", iconAction: { showDeleteAlert = true })], backAction: goBack)
            VStack {
                FidelityCardView(
                    title: fidelityCard.storeName,
                    headerColor: Color(hex: fidelityCard.backgroundColorHex),
                    barcodeText: fidelityCard.cardNumber,
                    height: 200,
                    width: 330
                )
                
                Spacer()
                    .frame(height: 40)
                
                GenericActionTile(iconName: "pencil", title: .editCard) {
                    segue = .editFidelityCardSegue
                }
                
                Spacer()
                    .frame(height: 10)
                
                GenericActionTile(iconName: "camera", title: .photos) {
                    segue = .cardPhotosSegue
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .alert(String.deleteCard, isPresented: $showDeleteAlert) {
            Button(String.deleteButton, role: .destructive, action: deleteCard)
            Button(String.cancelButton, role: .cancel) {}
        } message: {
            Text(String.deleteCardQuestion)
        }
    }
    
    private func goBack() {
        segue = navigateToHome ? .homeSegue : .fidelityCardsSegue
    }
    
    private func deleteCard() {
        let db = Firestore.firestore()
        let docRef = db.collection("homes").document(homeId)

        docRef.getDocument { document, error in
            guard let document = document, document.exists else {
                print("Home document not found: \(error?.localizedDescription ?? "")")
                return
            }

            let data = document.data() ?? [:]

            // 1. Remove from cards array
            var cards = data["sharedCards"] as? [[String: Any]] ?? []
            cards.removeAll { $0["cardNumber"] as? String == fidelityCard.cardNumber }

            // 2. Remove entry from sharedPhotos
            var sharedPhotos = data["sharedPhotos"] as? [String: [String: String]] ?? [:]
            sharedPhotos.removeValue(forKey: fidelityCard.cardNumber)

            // 3. Save changes to Firestore
            docRef.updateData([
                "sharedCards": cards,
                "sharedPhotos": sharedPhotos
            ]) { err in
                if let err = err {
                    print("Failed to delete card: \(err)")
                } else {
                    print("Card and shared photos deleted successfully")
                    goBack()
                }
            }
        }
    }
}
