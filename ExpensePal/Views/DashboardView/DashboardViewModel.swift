//
//  DashboardViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Observation
import SwiftUI
import ExpensePalModels
import Observation

@Observable
class DashboardViewModel {
    var expenseList: [Expense] = []
    var totalRecentExpenses: Double = 0
    var localeIdentifier: String?

    init() {
        getRecentExpenses()
        localeIdentifier = UserDefaults.standard.string(forKey: "localeIdentifier")
    }

    func getRecentExpenses() {
        totalRecentExpenses = expenseList.reduce(0) {
            let convertedVal = CurrencyConverter.shared.convert($1.cost, valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD), outputCurrency: Locales(localeIdentifier: localeIdentifier ?? "en_US")?.currency ?? .USD) ?? 0
            return $0 + convertedVal
        }
    }
}
