//
//  GenericTextField.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI

struct GenericTextField: View {
    var inputType: TextFieldInput
    @State private var isSecureVisible: Bool = false
    @Binding var text: String
    var textColor: Color = .white
       
    var body: some View {
       HStack {
           Image(systemName: inputType.iconName)
               .foregroundColor(.gray)
           
           Group {
               if inputType.isSecure && !isSecureVisible {
                   SecureField(LocalizedStringKey(inputType.placeholder), text: $text)
               } else {
                   TextField(LocalizedStringKey(inputType.placeholder), text: $text)
                       .foregroundColor(textColor)
               }
           }
           .font(Fonts.regular.ofSize(15))
           .keyboardType(inputType.keyboardType)
           .autocapitalization(.none)
           
           if inputType.isSecure {
               Button(action: {
                   isSecureVisible.toggle()
               }) {
                   Image(systemName: isSecureVisible ? "eye" : "eye.slash")
                       .foregroundColor(.gray)
               }
           }
       }
       .padding(.vertical, 20)
       .padding(.horizontal)
       .background(Color(.appMediumDark))
       .cornerRadius(12)
       .padding(.horizontal)
    }
}

struct EmailTextField_Previews: PreviewProvider {
    @State static var previewText = ""

    static var previews: some View {
        GenericTextField(inputType: .email, text: $previewText)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
