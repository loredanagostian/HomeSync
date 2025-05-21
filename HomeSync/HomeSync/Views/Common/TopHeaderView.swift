//
//  TopHeaderView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 20.05.2025.
//

import SwiftUI

struct IconButton {
    let iconName: String
    let iconAction: () -> Void
}

struct TopHeaderView: View {
    var screenTitle: String
    var icons: [IconButton]
    var backAction: () -> Void

    var body: some View {
        ZStack {
            HStack {
                Button(action: backAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                }

                Spacer()

                HStack(spacing: 16) {
                    ForEach(icons, id: \.iconName) { icon in
                        Button(action: icon.iconAction) {
                            Image(systemName: icon.iconName)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                }
            }

            GenericTextView(
                text: screenTitle,
                font: Fonts.regular.ofSize(20),
                textColor: .white
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
}
