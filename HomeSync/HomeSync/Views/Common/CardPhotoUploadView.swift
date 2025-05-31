//
//  CardPhotoUploadView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI

struct CardPhotoUploadView: View {
    let title: String
    let image: UIImage?
    let onDelete: () -> Void
    var isLoading: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.appMediumDark)
                    .frame(height: 500)
                    .overlay(
                        ZStack {
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 500)
                                    .clipped()
                                    .cornerRadius(15)
                            } else {
                                if !isLoading {
                                    GenericTextView(
                                        text: title,
                                        font: Fonts.regular.ofSize(20),
                                        textColor: .appPurple
                                    )
                                }
                            }

                            if isLoading {
                                Color.black.opacity(0.4)
                                    .cornerRadius(15)
                                    .frame(height: 500)

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .appPurple))
                                    .scaleEffect(2.0)
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                if image != nil && !isLoading {
                    Button(action: { onDelete() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(5)
                    .zIndex(1)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}
