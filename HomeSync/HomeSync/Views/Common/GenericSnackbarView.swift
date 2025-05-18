//
//  GenericSnackbarView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct GenericSnackbarView: View {
    var message: String

    var body: some View {
        Text(message)
            .frame(height: 45)
            .font(Fonts.semiBold.ofSize(14))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.red.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(width: 350)
            .padding(.bottom, 50)
    }
}
