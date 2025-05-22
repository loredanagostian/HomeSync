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

    var placeholder: String {
        switch self {
        case .email: return .enterEmail
        case .password: return .enterPassword
        case .confirmPassword: return .confirmPassword
        case .firstName: return .enterFirstName
        case .lastName: return .enterLastName
        case .homeName: return .homeName
        }
    }

    var iconName: String {
        switch self {
        case .email: return "envelope"
        case .password: return "lock"
        case .confirmPassword: return "checkmark.circle"
        case .firstName, .lastName: return "person"
        case .homeName: return ""
        }
    }

    var isSecure: Bool {
        switch self {
        case .email, .firstName, .lastName, .homeName: return false
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
