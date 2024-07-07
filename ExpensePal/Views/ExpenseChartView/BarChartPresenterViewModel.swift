//
//  BarChartPresenterViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import Foundation

extension BarChartPresenter {
    class ViewModel {

        var averageSpending: Double = 0

        func getExpenseChartDataPoints(_ filter: ExpenseChartMainFilter, _ allEntries: [Expense]) -> [LinePlot] {
            let linePlots: [LinePlot] = switch filter {
            case .Month:
                monthWiseExpense(allEntries)
            case .Year:
                []
            case .Week:
                dailyWiseExpense(allEntries)
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
                if let startOfMonth = expense.date.startOfMonth() {
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

            var totalForAverage: Double = 0

            for (date, expenses) in expensesByMonth {
                let totalAmount = expenses.reduce(0) { $0 + $1.cost }
                totalForAverage += totalAmount
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlot(
                    xValueType: "Month",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }
            if !expensesByMonth.isEmpty {
                averageSpending = totalForAverage / Double(expensesByMonth.count)
            }
            let plotPoints = linePlotList.sorted(using: KeyPathComparator(\.xValue))
            return plotPoints
        }

        private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
            // From here to
            var expensesByDay: [Date: [Expense]] = [:]

            // Get the current calendar and the current date
            let calendar = Calendar.current
            let currentDate = Date()
            // Testing
//            let currentDate = calendar.date(byAdding: .day, value: -1, to: Date())!

            // Determine the start of the week
            let thisWeekDay = calendar.component(.weekday, from: currentDate)
//            let startOfTheWeekDay = calendar.firstWeekday
            let startOfWeek = calendar.date(
                byAdding: .day,
                value: -(thisWeekDay - calendar.firstWeekday),
                to: calendar.startOfDay(for: currentDate)
            )!

            for dayOffset in 0..<thisWeekDay {
                if let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                    expensesByDay[day] = []
                }
            }

            // Populate expensesByDay with actual expenses
            for expense in allEntries {
                let date = calendar.startOfDay(for: expense.date)
                expensesByDay[date]?.append(expense)
            }

            // Check for days with zero expenses and set them
            for day in expensesByDay.keys {
                if expensesByDay[day]?.isEmpty ?? true {
                    expensesByDay[day] = [Expense(emoji: "", title: "", cost: 0, date: day)]
                }
            }
            var linePlotList: [LinePlot] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            var totalForAverage: Double = 0
            for (date, expenses) in expensesByDay {
                let totalAmount = expenses.reduce(0) { $0 + $1.cost }
                totalForAverage += totalAmount
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlot(
                    xValueType: "Day",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }
            
            if !expensesByDay.isEmpty {
                averageSpending = totalForAverage / Double(expensesByDay.count)
            }

            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }
    }
}
