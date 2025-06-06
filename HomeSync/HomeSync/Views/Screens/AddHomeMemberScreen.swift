//
//  AddHomeMemberScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 06.06.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddHomeMemberScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    @Binding var homeMembers: [HomeUser]
    
    @State private var searchText: String = ""
    @State private var allUsers: [HomeUser] = []
    @State private var filteredUsers: [HomeUser] = []
    
    var body: some View {
        VStack(spacing: 0) {
            TopHeaderView(screenTitle: .addHomeMember, icons: [], backAction: goBack)
            
            VStack {
                TextField("Search", text: $searchText)
                    .padding(12)
                    .background(Color(.appMediumDark))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .onChange(of: searchText) { _, newValue in
                        filterUsers()
                    }
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredUsers) { user in
                            HomeMemberRow(
                                member: user,
                                buttonVisible: !homeMembers.contains(where: { $0.id == user.id }),
                                isRemove: false,
                                onPress: {
                                    addUserToHome(userId: user.id, homeId: homeId) { success in
                                        if success {
                                            goBack()
                                        } else {
                                            print("Failed.")
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: loadUsers)
    }
    
    private func goBack() {
        segue = .homeMembersSegue
    }
    
    private func loadUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let users: [HomeUser] = documents.compactMap { doc in
                let data = doc.data()
                guard let firstName = data["firstName"] as? String,
                      let lastName = data["lastName"] as? String,
                      let email = data["email"] as? String else {
                    return nil
                }

                let fullName = "\(firstName) \(lastName)"
                return HomeUser(id: doc.documentID, fullName: fullName, email: email)
            }

            allUsers = users
            filteredUsers = users
        }
    }
    
    func addUserToHome(userId: String, homeId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let homeRef = db.collection("homes").document(homeId)
        let userRef = db.collection("users").document(userId)

        let batch = db.batch()

        // Update homes/{homeId}/usersId
        batch.updateData([
            "usersId": FieldValue.arrayUnion([userId])
        ], forDocument: homeRef)

        // Update users/{userId}/homesId
        batch.updateData([
            "homesId": FieldValue.arrayUnion([homeId])
        ], forDocument: userRef)

        // Commit both updates
        batch.commit { error in
            if let error = error {
                print("Failed to add user to home: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User successfully added to home.")
                completion(true)
            }
        }
    }

    private func filterUsers() {
        if searchText.isEmpty {
              filteredUsers = allUsers
        } else {
            filteredUsers = allUsers.filter {
                $0.email.lowercased().contains(searchText.lowercased()) ||
                $0.fullName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
