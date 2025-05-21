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
    
    init() {
       // Determine initial screen based on auth state
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
                HomeScreen(segue: $segue)
                
            case .completeProfileSegue:
                CompleteProfileScreen(segue: $segue)
                
            case .fidelityCardsSegue:
                FidelityCardsScreen(segue: $segue)
                
            case .fidelityCardSegue:
                FidelityCardScreen(segue: $segue, cardName: .constant("Auchan"))
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
