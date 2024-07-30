//
//  ExpensePalApp.swift
//  ExpensePal
//
//  Created by Gokul P on 08/06/24.
//

import SwiftUI
import SwiftData

@main
struct ExpensePalApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .modifier(DarkModeViewModifier())
        }
        .modelContainer(for: Expense.self)
    }
}
