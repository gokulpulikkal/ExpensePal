//
//  QueryFetchHelpers.swift
//  ExpensePal
//
//  Created by Gokul P on 19/06/24.
//

import SwiftData
import SwiftUI

extension Expense {
    
    static func currentYearPredicate() -> Predicate<Expense> {
        let firstDayOfYear = Date().firstDayOfYear() ?? Date()

        return #Predicate<Expense> { expense in
            expense.date > firstDayOfYear
        }
    }

    static func recentExpensesPredicate() -> Predicate<Expense> {
        let currentDate = Date.now

        return #Predicate<Expense> { festival in
            festival.date < currentDate
        }
    }
    
    static func firstTen() -> FetchDescriptor<Expense> {
        var fetch = FetchDescriptor<Expense>()
        fetch.sortBy = [SortDescriptor(\Expense.date)]
        // set your fetch limite here
        fetch.fetchLimit = 10
        return fetch
    }
}
