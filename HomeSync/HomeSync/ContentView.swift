//
//  ContentView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 12.05.2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    @State var segue: Segues = .loginSegue
    @State var cardName: String = ""
    @State var barcodeString: String = ""
    @State var homeId: String = ""
    @State var fidelityCard: FidelityCardItem = FidelityCardItem(backgroundColorHex: "", cardNumber: "", storeName: "")
    @State var navigateToHome: Bool = false
    
    init() {
       if Auth.auth().currentUser != nil {
           _segue = State(initialValue: .homeSegue)
       } else {
           _segue = State(initialValue: .loginSegue)
       }
    }

    var body: some View {
        VStack(alignment: .leading) {
            switch segue {
            case .loginSegue:
                LoginScreen(segue: $segue)
                    .environmentObject(authService)
                
            case .registerSegue:
                RegisterScreen(segue: $segue)
                
            case .homeSegue:
                HomeScreen(segue: $segue, homeId: $homeId, fidelityCard: $fidelityCard, navigateToHome: $navigateToHome)
                
            case .completeProfileSegue:
                CompleteProfileScreen(segue: $segue)
                
            case .fidelityCardsSegue:
                FidelityCardsScreen(segue: $segue, barcodeString: $barcodeString, homeId: $homeId, fidelityCard: $fidelityCard, navigateToHome: $navigateToHome)
                
            case .fidelityCardSegue:
                FidelityCardScreen(segue: $segue, fidelityCard: $fidelityCard, navigateToHome: $navigateToHome, homeId: $homeId)
                
            case .addNewFidelityCardSegue:
                AddFidelityCardScreen(segue: $segue, barcodeString: $barcodeString, homeId: $homeId)
                
            case .editFidelityCardSegue:
                EditFidelityCardScreen(segue: $segue, homeId: $homeId, fidelityCard: $fidelityCard)
                
            case .cardPhotosSegue:
                CardPhotosScreen(segue: $segue, fidelityCard: $fidelityCard, homeId: $homeId)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appDark)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
