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
    private let sceneNavigationModel: NavigationModel
    
    init() {
        let navigationModel = NavigationModel(selectedTab: nil)
        sceneNavigationModel = navigationModel
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
        .modelContainer(for: Expense.self)
//        .modelContainer(previewContainer)
        .environment(sceneNavigationModel)
    }
}
