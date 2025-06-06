//
//  HomeMembersScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 06.06.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeMembersScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    @Binding var homeMembers: [HomeUser]
    
    @State private var showDeleteAlert: Bool = false
    @State private var showSnackbar: Bool = false
    @State private var selectedUserIdToDelete: String?
    
    var body: some View {
        VStack {
           TopHeaderView(
               screenTitle: .homeMembers,
               icons: [IconButton(iconName: "person.badge.plus", iconAction: { segue = .addHomeMemberSegue })],
               backAction: { segue = .editHomeSegue }
           )
           
         ScrollView {
               LazyVStack(spacing: 16) {
                   ForEach(homeMembers) { member in
                       HomeMemberRow(member: member, buttonVisible: member.id != Auth.auth().currentUser!.uid, isRemove: true) {
                           selectedUserIdToDelete = member.id
                           showDeleteAlert = true
                       }
                   }
               }
               .padding()
           }
        }
        .onAppear(perform: loadMembers)
        .overlay(snackbarView)
        .alert(String.removeMember, isPresented: $showDeleteAlert) {
            Button(String.deleteButton, role: .destructive) {
                if let userId = selectedUserIdToDelete {
                    removeUserFromHome(userId: userId)
                }
            }
            Button(String.cancelButton, role: .cancel) {}
        } message: {
            Text(String.deleteHomeQuestion)
        }
    }
    
    private func goBack() {
        segue = .editHomeSegue
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
                self.homeMembers = loadedMembers
            }
        }
       
    private func removeUserFromHome(userId: String) {
        let db = Firestore.firestore()
        let homeRef = db.collection("homes").document(homeId)
        let userRef = db.collection("users").document(userId)

        let batch = db.batch()

        // Remove user from home's usersId
        batch.updateData([
            "usersId": FieldValue.arrayRemove([userId])
        ], forDocument: homeRef)

        // Remove home from user's homesId
        batch.updateData([
            "homesId": FieldValue.arrayRemove([homeId])
        ], forDocument: userRef)

        // Commit the batch
        batch.commit { error in
            if let error = error {
                print("Error removing user from home: \(error.localizedDescription)")
                showSnackbar = true
            } else {
                withAnimation {
                    homeMembers.removeAll { $0.id == userId }
                }
            }
        }
    }
    
    private var snackbarView: some View {
        VStack {
            Spacer()
            if showSnackbar {
                GenericSnackbarView(message: .removeMemberError)
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onEnded { if $0.translation.height > 20 {
                                withAnimation { showSnackbar = false }
                            }}
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showSnackbar)
            }
        }
    }
}
