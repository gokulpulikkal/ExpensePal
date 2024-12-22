//
//  ExpensePalApp.swift
//  ExpensePal
//
//  Created by Gokul P on 08/06/24.
//
import AppIntents
import ExpensePalModels
import SwiftData
import SwiftUI

@main
struct ExpensePalApp: App {

    let container: ModelContainer

    private let sceneNavigationModel: NavigationModel

    init() {
        ExpenseShortcuts.updateAppShortcutParameters()
        do {
            container = try ModelContainer(for: Expense.self)
            SwiftDataServiceForAppIntents.shared.modelContext = container.mainContext
        } catch  {
            fatalError("Failed to configure SwiftData container.")
        }
        let navigationModel = NavigationModel(selectedTab: nil)
        self.sceneNavigationModel = navigationModel

        AppDependencyManager.shared.add(dependency: navigationModel)
    }

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
        .modelContainer(container)
//        .modelContainer(previewContainer)
        .environment(sceneNavigationModel)
    }
}
