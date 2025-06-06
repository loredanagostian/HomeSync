//
//  DropdownOverlay.swift
//  HomeSync
//
//  Created by Loredana Gostian on 07.06.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DropdownOverlay: View {
    @Binding var homes: [HomeEntry]
    @Binding var selectedHome: HomeEntry
    @Binding var isVisible: Bool
    @Binding var segue: Segues
    @State private var isAddingNewHome = false
    @State private var isEditingHome = false
    @State private var newHomeName = ""

    var body: some View {
        ZStack(alignment: .top) {
            if !isAddingNewHome {
                VStack(spacing: 8) {
                    Spacer().frame(height: 110)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(homes.indices, id: \.self) { index in
                            let home = homes[index]
                            
                            VStack(spacing: 0) {
                                Button(action: {
                                    selectedHome = home
                                    isVisible = false
                                }) {
                                    HStack(spacing: 12) {
                                        CircularIconButton(systemIconName: "homekit", action: {}, size: 18)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            GenericTextView(text: home.name, font: Fonts.regular.ofSize(16), textColor: .white)
                                            GenericTextView(text: "\(home.members) member\(home.members == 1 ? "" : "s")", font: Fonts.regular.ofSize(13), textColor: .white.opacity(0.6))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(.appBlack)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Rectangle()
                                    .fill(Color.appDark)
                                    .frame(height: 1)
                                    .padding(.horizontal, 12)
                            }
                        }
                        
                        Button(action: {
                            isEditingHome = true
                            segue = .editHomeSegue
                        }) {
                            HStack(spacing: 12) {
                                CircularIconButton(systemIconName: "pencil", action: {}, buttonColor: .appPurple)
                                GenericTextView(text: .editHome, font: Fonts.medium.ofSize(16), textColor: .white)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(.appBlack)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Rectangle()
                            .fill(Color.appDark)
                            .frame(height: 1)
                        
                        Button(action: {
                            isAddingNewHome = true
                        }) {
                            HStack(spacing: 12) {
                                CircularIconButton(systemIconName: "plus", action: {}, buttonColor: .appPurple)
                                GenericTextView(text: .addNewHome, font: Fonts.medium.ofSize(16), textColor: .white)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(.appBlack)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .background(.appBlack)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        
        ZStack {
            if isAddingNewHome {
                VStack(spacing: 40) {
                   GenericTextView(text: .addNewHome, font: Fonts.medium.ofSize(16), textColor: .white)
                   
                   GenericTextField(inputType: .homeName, text: $newHomeName)
                       .frame(maxWidth: .infinity)

                   Spacer()

                    GenericButton(title: .continueButton, action: {
                        guard let userId = Auth.auth().currentUser?.uid else {
                            print("No authenticated user")
                            return
                        }

                        let db = Firestore.firestore()
                        let homeRef = db.collection("homes").document() // create a ref with a known ID
                        let homeId = homeRef.documentID

                        let homeData: [String: Any] = [
                            "name": newHomeName,
                            "usersId": [userId],
                            "sharedPhotos": [],
                            "sharedCards": []
                        ]

                        homeRef.setData(homeData) { error in
                            if let error = error {
                                print("Error creating home: \(error.localizedDescription)")
                                return
                            }

                            let newHome = HomeEntry(id: homeId, name: newHomeName, members: 1)
                            selectedHome = newHome
                            homes.append(newHome)
                            isAddingNewHome = false
                            isVisible = false
                        }
                    })
                    .frame(maxWidth: .infinity)
                }
                .padding(24)
                .background(.appBlack)
                .cornerRadius(15)
                .frame(maxWidth: 400, maxHeight: 300)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex(5)
    }
}
