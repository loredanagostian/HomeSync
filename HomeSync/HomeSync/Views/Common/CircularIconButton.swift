//
//  CircularIconButton.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct CircularIconButton: View {
    var systemIconName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.appMediumDark)
                .clipShape(Circle())
        }
    }
}
