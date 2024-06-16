//
//  DashboardViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI
import Observation

@Observable class DashboardViewModel {
    var expenseList: [Expense] = []
    var totalRecentExpenses: Double = 0
    
    init() {
        getRecentExpenses()
    }
    
    private func getRecentExpenses() {
        expenseList = MockData.mockExpenseList
        totalRecentExpenses = expenseList.reduce(0, { $0 + $1.cost })
    }
}
