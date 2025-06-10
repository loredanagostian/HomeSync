//
//  ExpenseTileView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 11.06.2025.
//

import SwiftUI

struct ExpenseTileView: View {
    let expenseName: String
    let paidBy: String
    let totalAmount: Double
    let splitAmount: Double
    let date: Date
    let onMarkAsPaid: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "list.bullet.rectangle.portrait")
                .font(.system(size: 24))
                .foregroundColor(.appPurple)
                .frame(width: 44, height: 44)
                .background(Color.appPurple.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(expenseName)
                    .font(.headline)
                Text("Paid by \(paidBy)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("Total: $\(String(format: "%.2f", totalAmount))")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)

                Text("Split: $\(String(format: "%.2f", splitAmount))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.appMediumDark)
        .cornerRadius(12)
    }
}
