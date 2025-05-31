//
//  Enums.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import UIKit

enum TextFieldInput {
    case email
    case password
    case confirmPassword
    case firstName
    case lastName
    case homeName
    case cardNumber
    case storeName

    var placeholder: String {
        switch self {
        case .email: return .enterEmail
        case .password: return .enterPassword
        case .confirmPassword: return .confirmPassword
        case .firstName: return .enterFirstName
        case .lastName: return .enterLastName
        case .homeName: return .homeName
        case .cardNumber: return .cardNumber
        case .storeName: return .storeName
        }
    }

    var iconName: String {
        switch self {
        case .email: return "envelope"
        case .password: return "lock"
        case .confirmPassword: return "checkmark.circle"
        case .firstName, .lastName: return "person"
        case .homeName, .cardNumber, .storeName: return ""
        }
    }

    var isSecure: Bool {
        switch self {
        case .email, .firstName, .lastName, .homeName, .cardNumber, .storeName: return false
        case .password, .confirmPassword: return true
        }
    }
    
    var keyboardType: UIKeyboardType {
       switch self {
       case .email: return .emailAddress
       default: return .default
       }
   }
}

enum Tab {
    case split, home, more
}
