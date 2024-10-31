//
//  AddNewExpenseIntent.swift
//  ExpensePal
//
//  Created by Gokul P on 31/10/24.
//

import AppIntents

struct AddNewExpenseIntent: AppIntent {

    static var title: LocalizedStringResource = "Add a new expense to ExpensePal"

    static var description = IntentDescription("Opens the app and goes to your add expense view.")

    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationModel.setSelectedTab(.AddExpense)
        return .result()
    }

    @Dependency
    private var navigationModel: NavigationModel
}
