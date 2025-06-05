//
//  EditHomeScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 05.06.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditHomeScreen: View {
    @Binding var segue: Segues
    @Binding var homeId: String
    
    @State private var currentHome: HomeEntry?
    @State private var currentHomeName: String = ""
    @State private var newHomeName: String = ""
    @State private var isEditingHomeName = false
    @State private var homeNameChanged = false
    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""
    @State private var snackbarColor: Color = .green
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                TopHeaderView(screenTitle: currentHomeName, icons: [], backAction: goBack)
                VStack {
                    actionTiles
                    Spacer()
                }
                .padding()
            }
            
            if isEditingHomeName {
                editHomeNameModal
            }
        }
        .onAppear(perform: loadHome)
        .onChange(of: homeNameChanged) { _, changed in
            if changed {
                currentHomeName = newHomeName
            }
        }
        .overlay(snackbarView)
        .alert("\(String.deleteHome)?", isPresented: $showDeleteAlert) {
            Button(String.deleteButton, role: .destructive) {
                deleteHome { success in
                    if success {
                        segue = .homeSegue
                    } else {
                        showSnackbar(message: .deleteHomeError, color: .red)
                    }
                }
            }
            Button(String.cancelButton, role: .cancel) {}
        } message: {
            Text(String.deleteHomeQuestion)
        }
    }

    // MARK: - Action Tiles
    private var actionTiles: some View {
        VStack(spacing: 10) {
            GenericActionTile(iconName: "square.and.pencil", title: .editHomeName) {
                isEditingHomeName = true
            }
            GenericActionTile(iconName: "person.2", title: .manageMembers) {
                segue = .homeMembersSegue
            }
            GenericActionTile(iconName: "trash", title: .deleteHome, isArrowVisible: false, color: .red) {
                showDeleteAlert = true
            }
        }
    }

    // MARK: - Edit Modal
    private var editHomeNameModal: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isEditingHomeName = false }

            VStack(spacing: 40) {
                GenericTextView(text: .editHomeName, font: Fonts.medium.ofSize(16), textColor: .white)
                GenericTextField(inputType: .homeName, text: $newHomeName)
                    .frame(maxWidth: .infinity)
                Spacer()
                GenericButton(title: .saveButton) {
                    updateHomeName { success in
                        isEditingHomeName = false
                        homeNameChanged = success
                        showSnackbar(message: success ? .editHomeNameSuccess : .editHomeNameError,
                                     color: success ? .green : .red)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(24)
            .background(.appBlack)
            .cornerRadius(15)
            .frame(maxWidth: 400, maxHeight: 300)
        }
        .zIndex(5)
    }

    // MARK: - Snackbar View
    private var snackbarView: some View {
        VStack {
            Spacer()
            if showSnackbar {
                GenericSnackbarView(message: snackbarMessage, color: snackbarColor)
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

    // MARK: - Actions
    private func goBack() {
        segue = .homeSegue
    }

    private func loadHome() {
        fetchHomeDetails { home in
            if let home = home {
                currentHome = home
                currentHomeName = home.name
                newHomeName = home.name
            } else {
                print("Home not found or access denied")
            }
        }
    }

    private func showSnackbar(message: String, color: Color) {
        snackbarMessage = message
        snackbarColor = color
        showSnackbar = true
    }

    private func fetchHomeDetails(completion: @escaping (HomeEntry?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion(nil)
            return
        }

        let homeRef = Firestore.firestore().collection("homes").document(homeId)
        homeRef.getDocument { document, error in
            if let error = error {
                print("Error fetching home: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let doc = document, doc.exists,
                  let data = doc.data(),
                  let name = data["name"] as? String,
                  let usersId = data["usersId"] as? [String],
                  usersId.contains(userId) else {
                print("Home not found or user not authorized.")
                completion(nil)
                return
            }

            completion(HomeEntry(id: doc.documentID, name: name, members: usersId.count))
        }
    }

    private func updateHomeName(completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("homes")
            .document(homeId)
            .updateData(["name": newHomeName]) { error in
                if let error = error {
                    print("Error updating home name: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }

    private func deleteHome(completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("homes")
            .document(homeId)
            .delete { error in
                if let error = error {
                    print("Error deleting home: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
}
