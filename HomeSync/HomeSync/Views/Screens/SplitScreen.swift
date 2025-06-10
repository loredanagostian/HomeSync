//
//  SplitScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 11.06.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SplitScreen: View {
    @Binding var homeId: String
    @Binding var homeMembers: [HomeUser]
    @State private var showAddExpenseSheet = false
    @State private var newExpenseName = ""
    @State private var newExpensePrice = ""
    @State private var settlementAmount: Double = 0.0
    @State private var expenses: [[String: Any]] = []
    
    private let db = Firestore.firestore()
    
    private var totalYouOwe: Double {
        expenses
            .filter { ($0["paidBy"] as? String) != Auth.auth().currentUser?.uid }
            .compactMap { $0["splitPrice"] as? Double }
            .reduce(0, +)
    }

    private var totalYouAreOwed: Double {
        expenses
            .filter { ($0["paidBy"] as? String) == Auth.auth().currentUser?.uid }
            .compactMap { $0["splitPrice"] as? Double }
            .reduce(0, +)
    }
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .settlement, icons: [IconButton(iconName: "cart.badge.plus", iconAction: { showAddExpenseSheet = true })], backAction: {}, backIconVisible: false)
            
            VStack {
                BalanceCardView(
                    amountOwedToYou: totalYouAreOwed,
                    amountYouOwe: totalYouOwe
                )

                HStack {
                    GenericTextView(text: .recentExpenses, font: Fonts.semiBold.ofSize(20), textColor: .white)
                    Spacer()
                }
                .padding(.vertical)
                
                ScrollView {
                   VStack(spacing: 12) {
                       ForEach(expenses.indices, id: \.self) { index in
                           let expense = expenses[index]
                           
                           ExpenseTileView(
                               expenseName: expense["name"] as? String ?? "Unknown",
                               paidBy: resolveUserName(userId: expense["paidBy"] as? String),
                               totalAmount: expense["totalPrice"] as? Double ?? 0.0,
                               splitAmount: expense["splitPrice"] as? Double ?? 0.0,
                               date: (expense["date"] as? Timestamp)?.dateValue() ?? Date()
                           ) {
                               print("Mark as paid not yet implemented")
                           }
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
                    guard let total = Double(newExpensePrice) else { return }
                    
                    let newExpense: [String: Any] = [
                        "name": newExpenseName,
                        "totalPrice": total,
                        "splitPrice": total / Double(homeMembers.count),
                        "paidBy": Auth.auth().currentUser!.uid,
                        "date": Timestamp(date: Date())
                    ]

                    let homeRef = db.collection("homes").document(homeId)

                    // Use Firestore transaction to append expense + update amount
                    db.runTransaction({ (transaction, errorPointer) -> Any? in
                        let snapshot: DocumentSnapshot
                        do {
                            snapshot = try transaction.getDocument(homeRef)
                        } catch {
                            errorPointer?.pointee = error as NSError
                            return nil
                        }

                        var settlement = snapshot.data()?["settlement"] as? [String: Any] ?? [:]
                        var expenses = settlement["expenses"] as? [[String: Any]] ?? []
                        var currentAmount = settlement["settlementAmount"] as? Double ?? 0

                        expenses.append(newExpense)
                        currentAmount += total / Double(homeMembers.count)

                        settlement["expenses"] = expenses

                        transaction.updateData(["settlement": settlement], forDocument: homeRef)
                        return nil
                    }) { err, _ in
                        if let err = err {
                            print("Error adding expense: \(err)")
                        } else {
                            print("Expense added successfully.")
                            fetchSettlement()
                        }

                        newExpenseName = ""
                        newExpensePrice = ""
                        showAddExpenseSheet = false
                    }
                },
                onCancel: {
                    newExpenseName = ""
                    newExpensePrice = ""
                    showAddExpenseSheet = false
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            fetchSettlement()
        }
    }
    
    private func fetchSettlement() {
        let homeRef = db.collection("homes").document(homeId)

        homeRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching settlement: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let settlement = data["settlement"] as? [String: Any] {
                self.settlementAmount = settlement["settlementAmount"] as? Double ?? 0.0
                self.expenses = settlement["expenses"] as? [[String: Any]] ?? []
            }
        }
    }
    
    private func resolveUserName(userId: String?) -> String {
        guard let userId = userId else { return "Unknown" }
        return homeMembers.first(where: { $0.id == userId })?.fullName ?? "Unknown"
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
