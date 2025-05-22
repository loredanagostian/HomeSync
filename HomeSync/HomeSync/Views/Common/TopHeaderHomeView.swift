//
//  TopHeaderHomeView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct TopHeaderHomeView: View {
    @Binding var isDropdownVisible: Bool

    var userName: String
    var homeName: String
    var selectedHomeCallback: (HomeEntry) -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Spacer()
                    GenericTextView(text: homeName, font: Fonts.bold.ofSize(18), textColor: .white)
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isDropdownVisible ? 180 : 0))
                        .foregroundColor(.white)
                    Spacer()
                }
            }

            HStack {
                GenericTextView(text: userInitials(from: userName), font: Fonts.medium.ofSize(20), textColor: .white)
                    .frame(width: 50, height: 50)
                    .background(.appPurple)
                    .clipShape(Circle())

                Spacer()

                HStack(spacing: 12) {
                    CircularIconButton(systemIconName: "square.grid.2x2") {}
                    CircularIconButton(systemIconName: "bell.badge") {}
                }
            }
            }
        .padding(.horizontal)
    }

    private func userInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}

struct DropdownOverlay: View {
    let homes: [HomeEntry]
    @Binding var selectedHome: HomeEntry
    @Binding var isVisible: Bool
    @State private var isAddingNewHome = false
    @State private var newHomeName = ""

    var body: some View {
        ZStack(alignment: .top) {
            if !isAddingNewHome {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isVisible = false
                    }
                
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
                            isAddingNewHome = true
                        }) {
                            HStack(spacing: 12) {
                                CircularIconButton(systemIconName: "plus", action: {}, buttonColor: .appPurple)
                                GenericTextView(text: .addNewHome, font: Fonts.medium.ofSize(16), textColor: .appPurple)
                                Spacer()
                            }
                            .padding(.horizontal)
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
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isAddingNewHome = false
                    }

                VStack(spacing: 40) {
                   GenericTextView(text: .addNewHome, font: Fonts.medium.ofSize(16), textColor: .white)
                   
                   GenericTextField(inputType: .homeName, text: $newHomeName)
                       .frame(maxWidth: .infinity)

                   Spacer()

                   GenericButton(title: .continueButton, action: {})
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
