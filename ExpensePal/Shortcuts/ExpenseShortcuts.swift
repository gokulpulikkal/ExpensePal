//
//  ExpenseShortcuts.swift
//  ExpensePal
//
//  Created by Gokul P on 05/11/24.
//

import AppIntents
import Foundation

class ExpenseShortcuts: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenDashboard(),
            phrases: [
                "show the Dashboard in \(.applicationName)",
                "Open Dashboard in \(.applicationName)"
            ],
            shortTitle: "show the Dashboard",
            systemImageName: "shoeprints"
        )

        AppShortcut(
            intent: AddNewExpenseIntent(),
            phrases: [
                "Add my expense in \(.applicationName)"
            ],
            shortTitle: "Add a new Expense",
            systemImageName: "shoeprints.fill"
        )
    }

}
