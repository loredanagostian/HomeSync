//
//  MoreScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 07.06.2025.
//

import SwiftUI
import FirebaseAuth

struct MoreScreen: View {
    @Binding var segue: Segues

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("More Options")
                .font(.title2)
                .fontWeight(.bold)

            Button(action: logout) {
                Text("Log Out")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            segue = .loginSegue
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}
