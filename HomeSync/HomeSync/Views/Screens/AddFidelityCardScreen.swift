//
//  AddFidelityCardScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI
import FirebaseFirestore

struct AddFidelityCardScreen: View {
    @Binding var segue: Segues
    @Binding var barcodeString: String
    @Binding var homeId: String
    @State private var cardNumber = ""
    @State private var storeName = ""
    @State private var selectedColorHex = ColorPreset.colors.first!.hex
    
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
                    .padding(.horizontal)
                
                Spacer()
                    .frame(height: 15)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 20) {
                    ForEach(ColorPreset.colors, id: \.hex) { preset in
                        Circle()
                            .fill(preset.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectedColorHex == preset.hex ? Color.white : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedColorHex = preset.hex
                            }
                    }
                }
                .padding()
            }
            
            Spacer()

            GenericButton(title: .continueButton, action: addFidelityCard)
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .onAppear(perform: loadResources)
    }
    
    private func loadResources() {
        cardNumber = barcodeString
    }
    
    private func goBack() {
        segue = .fidelityCardsSegue
    }

    private func addFidelityCard() {
        let db = Firestore.firestore()

        let cardData: [String: Any] = [
            "cardNumber": cardNumber,
            "storeName": storeName,
            "colorHex": selectedColorHex
        ]

        db.collection("homes")
            .document(homeId)
            .updateData([
               "sharedCards": FieldValue.arrayUnion([cardData])
            ]) { error in
               if let error = error {
                   print("Error adding card: \(error.localizedDescription)")
               } else {
                   print("Fidelity card added to sharedCards array.")
                   segue = .fidelityCardsSegue
               }
            }
    }
}
