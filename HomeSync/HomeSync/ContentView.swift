//
//  ContentView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 12.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State var segue: Segues = .loginSegue

    var body: some View {
        VStack(alignment: .leading) {
            switch segue {
            case .loginSegue:
                LoginScreen()
                
            case .registerSegue:
                LoginScreen()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appDark)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
