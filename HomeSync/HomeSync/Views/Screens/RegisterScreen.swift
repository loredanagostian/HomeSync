//
//  RegisterScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI
import FirebaseAuth

struct RegisterScreen: View {
    @EnvironmentObject var authService: AuthService
    @Binding var segue: Segues
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSnackbar = false
    @State private var errorMessage = ""

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

                    GenericTextView(text: .signUp, font: Fonts.bold.ofSize(24), textColor: .white)
                    
                    Spacer()
                        .frame(height: 50)

                    GenericTextField(inputType: .email, text: $email)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    GenericTextField(inputType: .password, text: $password)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    GenericTextField(inputType: .confirmPassword, text: $confirmPassword)
                }
                .padding(.top, 60)
                .padding(.horizontal)
            }

            Spacer()

            GenericButton(title: .signUp, action: signUp)
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            HStack {
                GenericTextView(text: .notUserYet, font: Fonts.regular.ofSize(14), textColor: .white)
                GenericTextView(text: .signIn, font: Fonts.regular.ofSize(14), textColor: .appPurple)
                    .onTapGesture(perform: signIn)
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(Color.appDark)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(
            VStack {
                Spacer()
                if showSnackbar {
                    GenericSnackbarView(message: errorMessage)
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
    
    private func showError(_ message: String) {
        errorMessage = message
        withAnimation { showSnackbar = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showSnackbar = false }
        }
    }

    private func signUp() {
        guard password == confirmPassword else {
            showError(.passwordsNotMatch)
            return
        }

        authService.signUp(email: email, password: password) { success in
            if success {
                segue = .completeProfileSegue
            } else {
                showError(authService.errorMessage ?? .unknownError)
            }
        }
    }
    
    private func getFriendlyMessage(from error: NSError) -> String {
        switch AuthErrorCode(rawValue: error.code) {
        case .invalidEmail:
            return .emailBadlyFormatted
        case .emailAlreadyInUse:
            return .emailAlreadyRegistered
        case .weakPassword:
            return .passwordAtLeast6Chars
        case .networkError:
            return .networkError
        default:
            return error.localizedDescription
        }
    }
    
    private func signIn() {
        segue = .loginSegue
    }
}
