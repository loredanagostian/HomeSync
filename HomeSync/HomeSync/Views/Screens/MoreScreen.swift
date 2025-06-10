//
//  MoreScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 07.06.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MoreScreen: View {
    @Binding var segue: Segues
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var isLoading = true
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    @State private var showLogoutAlert = false
    
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .more, icons: [IconButton(iconName: "rectangle.portrait.and.arrow.forward", iconAction: { showLogoutAlert = true }, iconColor: .red)], backAction: {}, backIconVisible: false)
            VStack {
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    HStack {
                        GenericTextView(text: .profile.uppercased(), font: Fonts.bold.ofSize(14), textColor: .white.opacity(0.7))
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    GenericTextField(inputType: .firstName, text: $firstName)
                        .padding(.bottom)

                    GenericTextField(inputType: .lastName, text: $lastName)
                        .padding(.bottom)

                    GenericTextField(inputType: .email, text: $email, textColor: .white.opacity(0.7))
                        .disabled(true) // Email should not be editable
                        .padding(.bottom)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    GenericButton(title: .saveChanges, action: saveChanges)
                                        
                    Spacer()
                }
            }
            .padding()
        }
        .onAppear(perform: loadUserData)
        .overlay(
            VStack {
                Spacer()
                if showSnackbar {
                    GenericSnackbarView(message: snackbarMessage)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: showSnackbar)
                }
            }
        )
        .alert(String.logout, isPresented: $showLogoutAlert) {
            Button(String.logout, role: .destructive) {
                logout()
            }
            Button(String.cancelButton, role: .cancel) {}
        } message: {
            Text(String.logoutQuestion)
        }
    }

    private func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            self.snackbarMessage = "No authenticated user."
            self.showTemporarySnackbar()
            return
        }

        email = user.email ?? ""

        db.collection("users").document(user.uid).getDocument { document, error in
            isLoading = false
            if let document = document, document.exists {
                firstName = document.get("firstName") as? String ?? ""
                lastName = document.get("lastName") as? String ?? ""
            } else {
                self.snackbarMessage = "Failed to load user data."
                self.showTemporarySnackbar()
            }
        }
    }

    private func saveChanges() {
        guard let user = Auth.auth().currentUser else {
            self.snackbarMessage = "No authenticated user."
            self.showTemporarySnackbar()
            return
        }

        db.collection("users").document(user.uid).setData([
            "firstName": firstName,
            "lastName": lastName
        ], merge: true) { error in
            if let error = error {
                self.snackbarMessage = "Error saving changes: \(error.localizedDescription)"
            } else {
                self.snackbarMessage = "Changes saved successfully!"
            }
            self.showTemporarySnackbar()
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            segue = .loginSegue
        } catch {
            snackbarMessage = "Failed to sign out: \(error.localizedDescription)"
            showTemporarySnackbar()
        }
    }

    private func showTemporarySnackbar() {
        withAnimation { showSnackbar = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showSnackbar = false }
        }
    }
}
