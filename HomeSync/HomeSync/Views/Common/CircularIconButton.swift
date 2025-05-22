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
    var size: CGFloat = 18
    var buttonColor: Color = .appMediumDark
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(.white)
                .padding(2/3 * size)
                .background(buttonColor)
                .clipShape(Circle())
        }
    }
}
