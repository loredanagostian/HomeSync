//
//  AuthService.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import Foundation
import FirebaseAuth

class AuthService: ObservableObject {
    @Published var user: User?
    @Published var authError: String?
    @Published var errorMessage: String?

    init() {
        self.user = Auth.auth().currentUser
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authError = error.localizedDescription
                    completion(false)
                } else {
                    self.user = result?.user
                    self.authError = nil
                    completion(true)
                }
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authError = error.localizedDescription
                    completion(false)
                } else {
                    self.user = result?.user
                    self.authError = nil
                    completion(true)
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.authError = error.localizedDescription
        }
    }
}
