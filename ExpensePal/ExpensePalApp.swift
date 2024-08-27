//
//  ExpensePalApp.swift
//  ExpensePal
//
//  Created by Gokul P on 08/06/24.
//

import ExpensePalModels
import SwiftData
import SwiftUI

@main
struct ExpensePalApp: App {
    var body: some Scene {
        Group {
            WindowGroup {
                LaunchScreen()
                    .modifier(DarkModeViewModifier())
            }
            .defaultSize(width: 1200, height: 1000)
            WindowGroup("Add Expense", id: "addExpenseView") {
                AddExpenseView(viewModel: AddExpenseView.ViewModel())
                    .modifier(DarkModeViewModifier())
            }
            .defaultSize(width: 700, height: 700)
        }
        .modelContainer(for: Expense.self)
    }
}
