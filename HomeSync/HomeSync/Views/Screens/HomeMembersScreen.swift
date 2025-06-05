//
//  HomeMembersScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 06.06.2025.
//

import SwiftUI
import FirebaseFirestore

struct HomeUser: Identifiable {
    let id: String
    let fullName: String
    let email: String
}

struct HomeMembersScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    
    @State private var members: [HomeUser] = []
    
    var body: some View {
        VStack {
           TopHeaderView(
               screenTitle: .homeMembers,
               icons: [IconButton(iconName: "person.badge.plus", iconAction: {  })],
               backAction: { segue = .editHomeSegue }
           )
           
           if members.isEmpty {
               Spacer()
               Text("No members yet.")
                   .foregroundColor(.gray)
                   .padding()
               Spacer()
           } else {
               ScrollView {
                   LazyVStack(spacing: 16) {
                       ForEach(members) { member in
                           HomeMemberRow(member: member) {
                               removeUserFromHome(userId: member.id)
                           }
                       }
                   }
                   .padding()
               }
           }
        }
        .onAppear(perform: loadMembers)
//        .overlay(snackbarView)
//        .alert("\(String.deleteHome)?", isPresented: $showDeleteAlert) {
//            Button(String.deleteButton, role: .destructive) {
//                deleteHome { success in
//                    if success {
//                        segue = .homeSegue
//                    } else {
//                        showSnackbar(message: .deleteHomeError, color: .red)
//                    }
//                }
//            }
//            Button(String.cancelButton, role: .cancel) {}
//        } message: {
//            Text(String.deleteHomeQuestion)
//        }
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
                self.members = loadedMembers
            }
        }
       
       private func removeUserFromHome(userId: String) {
           let db = Firestore.firestore()
           let userRef = db.collection("homes").document(homeId).collection("users").document(userId)
           
           userRef.delete { error in
               if let error = error {
                   print("Error removing user: \(error.localizedDescription)")
               } else {
                   withAnimation {
                       members.removeAll { $0.id == userId }
                   }
               }
           }
       }
}

struct HomeMemberRow: View {
    let member: HomeUser
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            GenericTextView(
                text: userInitials(from: member.fullName),
                font: Fonts.medium.ofSize(20),
                textColor: .white
            )
            .frame(width: 50, height: 50)
            .background(.appPurple)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(member.fullName)
                    .fontWeight(.semibold)
                Text(member.email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: onRemove) {
                Text("Remove")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
    }
    
    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
