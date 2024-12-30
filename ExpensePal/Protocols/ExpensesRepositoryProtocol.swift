//
//  ExpensesRepositoryProtocol.swift
//  ExpensePal
//
//  Created by Gokul P on 12/25/24.
//

import Foundation
import ExpensePalModels

protocol ExpensesRepositoryProtocol {
    func getMonthlyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double)
    func getDailyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double)
    func getYearlyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double)
}
