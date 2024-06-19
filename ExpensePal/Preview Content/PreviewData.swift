//
//  PreviewData.swift
//  ExpensePal
//
//  Created by Gokul P on 17/06/24.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Expense.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let listOfExpenses = MockData().getMockDataFromJSON()
        for expense in listOfExpenses {
            container.mainContext.insert(expense)
        }
//        container.mainContext.insert(Expense(emoji: "🐶", title: "Pet care", subTitle: "Petco", cost: 179.0, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!))
//        container.mainContext.insert(Expense(emoji: "🍔", title: "Food", subTitle: "McDonald's", cost: 15.5, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!))
//        container.mainContext.insert(Expense(emoji: "🛍️", title: "Shopping", subTitle: "Mall", cost: 230.0, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!))
        return container
    } catch {
        fatalError("Error creating the preview container!")
    }
}()
