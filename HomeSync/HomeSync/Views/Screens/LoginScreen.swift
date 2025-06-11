//
//  LoginScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 13.05.2025.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authService: AuthService
    @Binding var segue: Segues
    @Binding var selectedTab: Tab
    @State private var email = ""
    @State private var password = ""
    @State private var showSnackbar = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(ImagesName.appLogo.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                    
                    Spacer()
                        .frame(height: 15)

                    GenericTextView(text: .signIn, font: Fonts.bold.ofSize(24), textColor: .white)
                    
                    Spacer()
                        .frame(height: 50)

                    GenericTextField(inputType: .email, text: $email)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    GenericTextField(inputType: .password, text: $password)
                }
                .padding(.top, 60)
                .padding(.horizontal)
            }

            Spacer()

            GenericButton(title: .signIn, action: signIn)
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            HStack {
                GenericTextView(text: .notUserYet, font: Fonts.regular.ofSize(14), textColor: .white)
                GenericTextView(text: .signUp, font: Fonts.regular.ofSize(14), textColor: .appPurple)
                    .onTapGesture(perform: signUp)
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(Color.appDark)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(
            VStack {
                Spacer()
                if showSnackbar, let message = authService.authError {
                    GenericSnackbarView(message: message)
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

    private func signIn() {
        authService.signIn(email: email, password: password) { success in
          if success {
              segue = .homeSegue
              selectedTab = .home
          } else {
              withAnimation {
                  showSnackbar = true
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                  withAnimation {
                      showSnackbar = false
                  }
              }
          }
        }
    }
    
    private func signUp() {
        segue = .registerSegue
    }
}
