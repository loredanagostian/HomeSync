//
//  InfoTile.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI

struct InfoTile: View {
    var label: String
    @Binding var value: String
    @Binding var textFieldInput: TextFieldInput

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GenericTextView(text: label, font: Fonts.regular.ofSize(14), textColor: .white.opacity(0.7))
            GenericTextField(inputType: textFieldInput, text: $value)
        }
        .padding(.vertical)
    }
}
