//
//  BarChartPresenterViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import Foundation

extension BarChartPresenter {
    class ViewModel {
        
        func getExpenseChartDataPoints(_ filter: ExpenseChartMainFilter, _ allEntries: [Expense]) -> [LinePlot] {
            let linePlots: [LinePlot] = switch filter {
            case .Month:
                monthWiseExpense(allEntries)
            case .Year:
                []
            case .Week:
                []
            }
            return linePlots
        }

        private func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
            var expensesByMonth: [Date: [Expense]] = [:]

            // Get the current calendar and the current date
            let calendar = Calendar.current
            let currentDate = Date() // Only to get previous month data. Should change this to Date()

            // Determine the start of the week
            let thisMonth = calendar.component(.month, from: currentDate)
            guard let firstDayOfYear = currentDate.firstDayOfYear() else {
                return []
            }

            for monthOffset in 0..<thisMonth {
                if let month = calendar.date(byAdding: .month, value: monthOffset, to: firstDayOfYear) {
                    expensesByMonth[month] = []
                }
            }

            for expense in allEntries {
                if var startOfMonth = expense.date.startOfMonth() {
                    expensesByMonth[startOfMonth]?.append(expense)
                }
            }

            for month in expensesByMonth.keys {
                if expensesByMonth[month]?.isEmpty ?? true {
                    expensesByMonth[month] = [Expense(emoji: "", title: "", cost: 0, date: month)]
                }
            }

            var linePlotList: [LinePlot] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            for (date, expenses) in expensesByMonth {
                let totalAmount = expenses.reduce(0) { $0 + $1.cost }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlot(
                    xValueType: "Month",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }
            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }
    }
}
