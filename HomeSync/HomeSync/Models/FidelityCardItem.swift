//
//  FidelityCardItem.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import Foundation
import SwiftUI

struct FidelityCardItem: Identifiable, Equatable {
    let id = UUID()
    let backgroundColorHex: String
    let cardNumber: String
    let storeName: String
}
