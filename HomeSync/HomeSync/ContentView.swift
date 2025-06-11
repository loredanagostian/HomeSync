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
    @State var homeMembers: [HomeUser] = []
    @State private var selectedTab: Tab = .home
    
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
                LoginScreen(segue: $segue, selectedTab: $selectedTab)
                    .environmentObject(authService)
                
            case .registerSegue:
                RegisterScreen(segue: $segue)
                
            case .homeSegue:
                HomeScreen(segue: $segue, homeId: $homeId, fidelityCard: $fidelityCard, navigateToHome: $navigateToHome, selectedTab: $selectedTab, homeMembers: $homeMembers)
                
            case .completeProfileSegue:
                CompleteProfileScreen(segue: $segue, selectedTab: $selectedTab)
                
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
                
            case .editHomeSegue:
                EditHomeScreen(segue: $segue, homeId: $homeId)
                
            case .homeMembersSegue:
                HomeMembersScreen(segue: $segue, homeId: $homeId, homeMembers: $homeMembers)
                
            case .addHomeMemberSegue:
                AddHomeMemberScreen(segue: $segue, homeId: $homeId, homeMembers: $homeMembers)
                
            case .moreSegue:
                MoreScreen(segue: $segue)
                
            case .splitSegue:
                SplitScreen(homeId: $homeId, homeMembers: $homeMembers)
            }
            
            if segue == .homeSegue || segue == .moreSegue || segue == .splitSegue {
               GenericTabBar(selectedTab: $selectedTab)
                   .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appDark)
        .ignoresSafeArea()
        .onChange(of: selectedTab) { _, newTab in
            switch newTab {
            case .home:
                segue = .homeSegue
            case .split:
                segue = .splitSegue
            case .more:
                segue = .moreSegue
            }
        }
    }
}

#Preview {
    ContentView()
}
