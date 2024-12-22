//
//  AddNewExpenseIntent.swift
//  ExpensePal
//
//  Created by Gokul P on 31/10/24.
//

import AppIntents
import ExpensePalModels
import SwiftData
import SwiftUI

struct AddNewExpenseIntent: AppIntent {

    static var title: LocalizedStringResource = "Add a new expense"

    static var description = IntentDescription("Adds an expense to the app while in background")

    static var openAppWhenRun = false

    @MainActor
    func perform() async throws -> some IntentResult {
        do {
            print("The title of the expense is \(title) and the amount of the expense is \(amount)")
            let localeIdentifier = UserDefaults.standard.string(forKey: "localeIdentifier")
            let expense = Expense(emoji: "🛍️", title: title, cost: amount, locale: localeIdentifier ?? "USA")
            try SwiftDataServiceForAppIntents.shared.add(expense)
        } catch {
            print("Error saving data ")
        }
        return .result()
    }

    @Parameter(title: "Expense Title", requestValueDialog: "What is title of your Expense?")
    var title: String

    @Parameter(title: "Expense Amount", requestValueDialog: "What amount would you like to record?")
    var amount: Double

    @Dependency
    private var navigationModel: NavigationModel

}
