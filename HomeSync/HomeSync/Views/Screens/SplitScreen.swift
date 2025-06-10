//
//  SplitScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 11.06.2025.
//

import SwiftUI

struct SplitScreen: View {
    @State private var showAddExpenseSheet = false
    @State private var newExpenseName = ""
    @State private var newExpensePrice = ""
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .settlement, icons: [IconButton(iconName: "cart.badge.plus", iconAction: { showAddExpenseSheet = true })], backAction: {}, backIconVisible: false)
            
            VStack {
                BalanceCardView()
                
                HStack {
                    GenericTextView(text: .recentExpenses, font: Fonts.semiBold.ofSize(20), textColor: .white)
                    Spacer()
                }
                .padding(.vertical)
                
                ScrollView {
                   VStack(spacing: 12) {
                       ExpenseTileView(
                           expenseName: "Groceries",
                           paidBy: "Alice",
                           totalAmount: 120.00,
                           splitAmount: 40.00,
                           date: Date()
                       ) {
                           print("Marked groceries as paid")
                       }

                       ExpenseTileView(
                           expenseName: "Electric Bill",
                           paidBy: "Bob",
                           totalAmount: 60.00,
                           splitAmount: 20.00,
                           date: Date()
                       ) {
                           print("Marked electric bill as paid")
                       }

                       ExpenseTileView(
                           expenseName: "Netflix",
                           paidBy: "You",
                           totalAmount: 45.00,
                           splitAmount: 15.00,
                           date: Date()
                       ) {
                           print("Marked Netflix as paid")
                       }
                   }
                }

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showAddExpenseSheet) {
            AddExpenseSheet(
                expenseName: $newExpenseName,
                expensePrice: $newExpensePrice,
                onSave: {
                    print("New Expense: \(newExpenseName) - $\(newExpensePrice)")
                    newExpenseName = ""
                    newExpensePrice = ""
                    showAddExpenseSheet = false
                },
                onCancel: {
                    newExpenseName = ""
                    newExpensePrice = ""
                    showAddExpenseSheet = false
                }
            )
            .presentationDetents([.height(500)])
            .presentationDragIndicator(.visible)
        }
    }
}

struct AddExpenseSheet: View {
    @Binding var expenseName: String
    @Binding var expensePrice: String
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(verbatim: .expenseDetails)) {
                    TextField(String.expenseName, text: $expenseName)
                    TextField(String.totalPrice, text: $expensePrice)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle(String.addExpense, displayMode: .inline)
            .navigationBarItems(
                leading: Button(String.cancelButton, action: onCancel),
                trailing: Button(String.saveButton, action: onSave).disabled(expenseName.isEmpty || expensePrice.isEmpty)
            )
        }
    }
}
