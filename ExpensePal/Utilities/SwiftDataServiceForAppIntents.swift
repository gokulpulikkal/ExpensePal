//
//  SwiftDataServiceForAppIntents.swift
//  ExpensePal
//
//  Created by Gokul P on 04/11/24.
//

import ExpensePalModels
import SwiftData

@Observable
class SwiftDataServiceForAppIntents {
    static let shared = SwiftDataServiceForAppIntents()

    private init() {}

    var modelContext: ModelContext?

    /// Insert new model instances
    func add(_ newExpense: Expense) throws {
        if let context = modelContext {
            context.insert(newExpense)
            try context.save()
        } else {
            print("New Context is Nil!")
        }
    }
}
