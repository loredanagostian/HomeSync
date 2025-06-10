//
//  HomeScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    @Binding var fidelityCard: FidelityCardItem
    @Binding var navigateToHome: Bool
    @Binding var selectedTab: Tab
    @State private var isDropdownVisible = false
    @State private var availableHomes: [HomeEntry] = []
    @State private var selectedHome: HomeEntry? = nil
    @State private var previewCards: [FidelityCardItem] = []
    @State private var userName: String = ""
    @State private var homeUsers: [HomeUser] = []

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 30) {
                        if let selected = selectedHome {
                            TopHeaderHomeView(
                                isDropdownVisible: $isDropdownVisible,
                                userName: userName,
                                homeName: selected.name,
                                selectedHomeCallback: { selectedHome = $0 }
                            )
                        }

                        if !previewCards.isEmpty {
                            self.initFidelityCardsSection()
                        }
                        
                        initSettlementSection()
                    }
                }
                .padding(.top, 60)
            }
            .background(.appDark)
            .ignoresSafeArea(edges: .bottom)

            if isDropdownVisible {
                if isDropdownVisible, let selected = selectedHome {
                    DropdownOverlay(
                        homes: $availableHomes,
                        selectedHome: Binding(get: {
                            selected
                        }, set: { newValue in
                            self.selectedHome = newValue
                        }),
                        isVisible: $isDropdownVisible,
                        segue: $segue
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            fetchUserHomesAndFidelityCards()
            userName = fetchCurrentUserUserName()
        }
        .onChange(of: selectedHome) {
            if let newHome = selectedHome {
                homeId = newHome.id
                fetchPreviewSharedCards(for: newHome.id)
                loadMembers()
            } else {
                homeId = ""
                previewCards = []
                homeUsers = []
            }
        }
    }

    private func initFidelityCardsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            initSectionView(sectionTitle: .fidelityCards)
            FidelityCardsListView(cards: $previewCards, fidelityCard: $fidelityCard, segue: $segue, navigateToHome: $navigateToHome)
        }
    }
    
    private func initSettlementSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            initSectionView(sectionTitle: .settlement)
            SettlementCardView(users: $homeUsers, onViewDetailsPressed: { selectedTab = .split })
        }
    }

    private func initSectionView(sectionTitle: String) -> some View {
        HStack {
            GenericTextView(text: sectionTitle, font: Fonts.semiBold.ofSize(20), textColor: .white)

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
    
    private func fetchCurrentUserUserName() -> String {
        guard let userName = Auth.auth().currentUser?.displayName else {
            print("User not authenticated")
            return ""
        }
        
        return userName
    }
    
    private func fetchUserHomesAndFidelityCards() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        db.collection("homes")
            .whereField("usersId", arrayContains: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching homes: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let fetchedHomes: [HomeEntry] = documents.compactMap { doc in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let usersId = data["usersId"] as? [String] else {
                        return nil
                    }

                    return HomeEntry(id: doc.documentID, name: name, members: usersId.count)
                }

                self.availableHomes = fetchedHomes

                // Default select first home
                if let first = fetchedHomes.first {
                    self.selectedHome = first
                    homeId = first.id
                    
                    fetchPreviewSharedCards(for: homeId)
                }
            }        
    }
    
    private func fetchPreviewSharedCards(for homeId: String) {
        let db = Firestore.firestore()

        db.collection("homes")
            .document(homeId)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching sharedCards: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data(),
                      let sharedCards = data["sharedCards"] as? [[String: Any]] else {
                    return
                }

                let firstThree = Array(sharedCards.prefix(3))

                self.previewCards = firstThree.map { cardDict in
                    FidelityCardItem(
                        backgroundColorHex: cardDict["colorHex"] as? String ?? "#FFFFFF",
                        cardNumber: cardDict["cardNumber"] as? String ?? "Unknown",
                        storeName: cardDict["storeName"] as? String ?? "Unknown"
                    )
                }
            }
    }

    private func loadMembers() {
        let db = Firestore.firestore()
        db.collection("homes").document(homeId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Failed to fetch home: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let usersId = data["usersId"] as? [String] else {
                print("No usersId found in home")
                return
            }

            fetchUsersDetails(userIds: usersId)
        }
    }
    
    private func fetchUsersDetails(userIds: [String]) {
        let db = Firestore.firestore()
        var loadedMembers: [HomeUser] = []
        let group = DispatchGroup()

        for userId in userIds {
            group.enter()
            db.collection("users").document(userId).getDocument { doc, _ in
                defer { group.leave() }

                if let doc = doc, let data = doc.data(),
                   let first = data["firstName"] as? String,
                   let last = data["lastName"] as? String,
                   let email = data["email"] as? String {
                    let user = HomeUser(id: userId, fullName: "\(first) \(last)", email: email)
                    loadedMembers.append(user)
                }
            }
        }

        group.notify(queue: .main) {
            self.homeUsers = loadedMembers
        }
    }
}
