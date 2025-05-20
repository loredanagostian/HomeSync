//
//  ViewExtension.swift
//  HomeSync
//
//  Created by Loredana Gostian on 20.05.2025.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 15.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
