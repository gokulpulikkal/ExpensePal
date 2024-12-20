//
//  HomeChartRefactoredModel.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import Foundation
import ExpensePalModels

// MARK: - HomeChartRefactored.ViewModel

extension HomeChartRefactored {
    
    class ViewModel {
        
        var localeIdentifier: String?
        var lastDataPointDateString: String?

        var maxYRange = 0
        var minYRange = 0
        
        init() {
            localeIdentifier = UserDefaults.standard.string(forKey: "localeIdentifier")
        }
        
        func getTotalExpenseForPlot(_ linePlots: [LinePlotEntry]) -> Double {
            return linePlots.reduce(0, { $0 + $1.yValue })
        }
        
        func saveLastPointOfPlot(_ filter: ExpenseChartFilter, _ plotList: [LinePlotEntry]) {
            if let lastPoint = plotList.last {
                lastDataPointDateString = getExpenseChartDataPointsXValue(filter, lastPoint.xValue)
            }
        }

        func getExpenseChartDataPointsXValue(_ filter: ExpenseChartFilter, _ date: Date) -> String {
            switch filter {
            case .monthly:
                date.formatDateToMonth()
            case .weekly:
                date.formatDateToWeekOfMonth()
            case .daily:
                date.formatDateToDayOfWeek()
            default:
                ""
            }
        }

        func getExpenseChartDataPoints(_ filter: ExpenseChartFilter, _ allEntries: [Expense]) -> [LinePlotEntry] {
            let linePlots: [LinePlotEntry] = switch filter {
            case .monthly:
                monthWiseExpense(allEntries)
            case .weekly:
                weekWiseExpense(allEntries)
            case .daily:
                dailyWiseExpense(allEntries)
            default:
                []
            }
            saveLastPointOfPlot(filter, linePlots)
            return linePlots
        }

        

        /// Helper function to get a date for a specific day offset from today
        func getDate(daysOffset: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -daysOffset, to: Date())!
        }

        private func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
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

            var linePlotList: [LinePlotEntry] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            for (date, expenses) in expensesByMonth {
                let totalAmount = expenses.reduce(0) {
                    let convertedVal = CurrencyConverter.shared.convert($1.cost, valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD), outputCurrency: Locales(localeIdentifier: localeIdentifier ?? "en_US")?.currency ?? .USD) ?? 0
                    return $0 + convertedVal
                }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlotEntry(
                    xValueType: "Month",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }

            minYRange = minExpense
            maxYRange = maxExpense

            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }

        private func weekWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
            var expensesByWeek: [Date: [Expense]] = [:]

            // Get the current calendar and the current date
            let calendar = Calendar.current
            let currentDate = Date() // Only to get previous month data. Should change this to Date()

            // Determine the start of the week
            let thisWeek = calendar.component(.weekOfMonth, from: currentDate)

            guard let startOfMonth = currentDate.startOfMonth() else {
                return []
            }
            for weekOffset in 0..<thisWeek {
                if let week = calendar.date(byAdding: .weekOfMonth, value: weekOffset, to: startOfMonth),
                   var startOfWeek = week.startOfWeek()
                {
                    if startOfWeek < startOfMonth {
                        startOfWeek = startOfMonth
                    }
                    expensesByWeek[startOfWeek] = []
                }
            }

            // Populate expensesByDay with actual expenses
            for expense in allEntries {
                if var startOfWeek = expense.date.startOfWeek() {
                    if startOfWeek < startOfMonth {
                        startOfWeek = startOfMonth
                    }
                    expensesByWeek[startOfWeek]?.append(expense)
                }
            }

            for week in expensesByWeek.keys {
                if expensesByWeek[week]?.isEmpty ?? true {
                    expensesByWeek[week] = [Expense(emoji: "", title: "", cost: 0, date: week)]
                }
            }

            var linePlotList: [LinePlotEntry] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            for (date, expenses) in expensesByWeek {
                let totalAmount = expenses.reduce(0) {
                    let convertedVal = CurrencyConverter.shared.convert($1.cost, valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD), outputCurrency: Locales(localeIdentifier: localeIdentifier ?? "en_US")?.currency ?? .USD) ?? 0
                    return $0 + convertedVal
                }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlotEntry(
                    xValueType: "Week",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }

            minYRange = minExpense
            maxYRange = maxExpense

            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }

        private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
            // From here to
            var expensesByDay: [Date: [Expense]] = [:]

            // Get the current calendar and the current date
            let calendar = Calendar.current
            let currentDate = Date()

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
            var linePlotList: [LinePlotEntry] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            for (date, expenses) in expensesByDay {
                let totalAmount = expenses.reduce(0) {
                    let convertedVal = CurrencyConverter.shared.convert($1.cost, valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD), outputCurrency: Locales(localeIdentifier: localeIdentifier ?? "en_US")?.currency ?? .USD) ?? 0
                    return $0 + convertedVal
                }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlotEntry(
                    xValueType: "Day",
                    yValueType: "Expense",
                    xValue: date,
                    yValue: totalAmount
                ))
            }

            minYRange = minExpense
            maxYRange = maxExpense

            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }
    }
}
