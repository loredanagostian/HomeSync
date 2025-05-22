//
//  CompleteProfileScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CompleteProfileScreen: View {
    @Binding var segue: Segues
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showSnackbar: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    GenericTextView(text: .completeProfile, font: Fonts.bold.ofSize(24), textColor: .white)
                    
                    Spacer()
                        .frame(height: 50)

                    GenericTextField(inputType: .firstName, text: $firstName)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    GenericTextField(inputType: .lastName, text: $lastName)
                }
                .padding(.top, 60)
                .padding(.horizontal)
            }

            Spacer()

            GenericButton(title: .finish, action: finishAction)
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(Color.appDark)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(
            VStack {
                Spacer()
                if showSnackbar {
                    GenericSnackbarView(message: .emptyFields)
                        .gesture(
                            DragGesture(minimumDistance: 10)
                                .onEnded { value in
                                    if value.translation.height > 20 {
                                        withAnimation {
                                            showSnackbar = false
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: showSnackbar)
                }
            }
        )
    }
    
    private func finishAction() {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            withAnimation { showSnackbar = true }
            return
        }

        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            withAnimation { showSnackbar = true }
            return
        }

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = "\(firstName) \(lastName)"
        changeRequest.commitChanges { error in
            if let error = error {
                print("Profile update failed: \(error.localizedDescription)")
            }
        }

        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": user.email ?? "",
            "homesId": []
        ]

        // 1. Save user first
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error saving user to Firestore: \(error.localizedDescription)")
                withAnimation { showSnackbar = true }
                return
            }

            // 2. Create home
            var homeRef: DocumentReference? = nil
            let homeData: [String: Any] = [
                "name": "My Home",
                "usersId": [user.uid],
                "sharedPhotos": [],
                "sharedCards": []
            ]

            homeRef = db.collection("homes").addDocument(data: homeData) { error in
                if let error = error {
                    print("Error creating home: \(error.localizedDescription)")
                    return
                }

                guard let homeId = homeRef?.documentID else { return }

                // 3. Update user document to include this home ID
                db.collection("users").document(user.uid).updateData([
                    "homesId": FieldValue.arrayUnion([homeId])
                ]) { error in
                    if let error = error {
                        print("Error updating user homesId: \(error.localizedDescription)")
                    }
                    segue = .homeSegue
                }
            }
        }
    }
}
