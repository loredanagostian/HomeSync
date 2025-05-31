//
//  BarcodeScannerWrapper.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI

struct BarcodeScannerWrapper: View {
    @Environment(\.dismiss) var dismiss
    var completion: (String) -> Void

    var body: some View {
        ZStack {
            BarcodeScannerView(completion: completion)
                .edgesIgnoringSafeArea(.all)

            Rectangle()
                .strokeBorder(Color.white, lineWidth: 3)
                .frame(width: 300, height: 150)
                .background(Color.clear)
                .cornerRadius(12)

            VStack {
                Spacer()
                GenericTextView(text: .scanBarcode, font: Fonts.regular.ofSize(24), textColor: .white)
            }
        }
        .background(Color.appDark)
    }
}
