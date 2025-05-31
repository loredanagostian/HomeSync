//
//  EditFidelityCardScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI
import FirebaseFirestore

struct EditFidelityCardScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    @Binding var fidelityCard: FidelityCardItem
    @State var cardNumber = ""
    @State var storeName = ""
    @State var selectedColorHex = ColorPreset.colors.first!.hex
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .addNewFidelityCard, icons: [], backAction: goBack)
            
            VStack(alignment: .leading) {
                InfoTile(label: .cardNumber, value: $cardNumber, textFieldInput: .constant(.cardNumber))
                
                Spacer()
                    .frame(height: 30)
                
                InfoTile(label: .storeName, value: $storeName, textFieldInput: .constant(.storeName))
                
                Spacer()
                    .frame(height: 30)
                
                GenericTextView(text: .chooseCardColor, font: Fonts.regular.ofSize(14), textColor: .white.opacity(0.7))
                
                Spacer()
                    .frame(height: 15)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 20) {
                    ForEach(ColorPreset.colors, id: \.hex) { preset in
                        Circle()
                            .fill(preset.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectedColorHex.lowercased() == preset.hex.lowercased() ? Color.white : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedColorHex = preset.hex
                            }
                    }
                }
                .padding()
            }
            .padding()
            
            Spacer()

            GenericButton(title: .saveButton, action: updateFidelityCard)
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .onAppear(perform: loadResources)
    }
    
    private func loadResources() {
        cardNumber = fidelityCard.cardNumber
        storeName = fidelityCard.storeName
        selectedColorHex = fidelityCard.backgroundColorHex
    }
    
    private func goBack() {
        segue = .fidelityCardSegue
    }

    private func updateFidelityCard() {
        let db = Firestore.firestore()
        let docRef = db.collection("homes").document(homeId)

        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  var sharedCards = data["sharedCards"] as? [[String: Any]] else {
                print("Failed to load existing cards")
                return
            }

            if let index = sharedCards.firstIndex(where: { ($0["cardNumber"] as? String) == cardNumber }) {
                sharedCards[index] = [
                    "cardNumber": cardNumber,
                    "storeName": storeName,
                    "colorHex": selectedColorHex
                ]

                docRef.updateData(["sharedCards": sharedCards]) { error in
                    if let error = error {
                        print("Error updating card: \(error.localizedDescription)")
                    } else {
                        print("Card updated.")
                        segue = .fidelityCardsSegue
                    }
                }
            } else {
                print("Card not found with number: \(cardNumber)")
            }
        }
    }
}
