//
//  HomeChartViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 18/06/24.
//

import Observation
import SwiftUI

class HomeChartViewModel {
    
    func dailyGroupingForCurrentWeek(_ allEntries: [Expense]) -> [String: [Expense]] {
        let now = Date()
        let startOfWeek = now.startOfWeek() ?? now
        let endOfWeek = now.endOfWeek() ?? now
        let currentWeekEntries = allEntries.filter { $0.date >= startOfWeek && $0.date <= endOfWeek }

        // Grouping expenses by day of the week
        let groupedExpenses = Dictionary(grouping: currentWeekEntries, by: { expense in
            expense.date.dayOfWeekString()
        })
        return groupedExpenses
    }

    func weeklyGrouping(_ allEntries: [Expense]) -> [String: [Expense]] {
        let now = Date.now
        let startOfMonth = now.startOfMonth() ?? now
        let endOfMonth = now.endOfMonth() ?? now
        let currentMonthEntries = allEntries.filter({ $0.date >= startOfMonth && $0.date <= endOfMonth })

        // Grouping expenses by week of the month
        let groupedExpenses = Dictionary(grouping: currentMonthEntries, by: { expense in
            "Week \(expense.date.weekOfMonth())"
        })
        return groupedExpenses
    }

    func monthlyGrouping(_ allEntries: [Expense]) -> [String: [Expense]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let groupedExpenses = Dictionary(grouping: allEntries, by: { dateFormatter.string(from: $0.date) })
        return groupedExpenses
    }

    func getExpenseChartDataPoints(_ filter: ExpenseChartFilter, _ allEntries: [Expense]) -> [LinePlotEntry] {
        switch filter {
        case .monthly:
            return monthWiseExpense(allEntries)
        case .weekly:
            return weekWiseExpense(allEntries)
        case .daily:
            return dailyWiseExpense(allEntries)
        default:
            return []
        }
    }
    
    private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        var dailyExpenseList: [LinePlotEntry] = []
        for (_, entries) in dailyGroupingForCurrentWeek(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let dayExpensePoint = LinePlotEntry(xValueType: "Day", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            dailyExpenseList.append(dayExpensePoint)
        }
        return dailyExpenseList.sorted(using: KeyPathComparator(\.xValue))
    }

    private func weekWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        var weeklyExpenseList: [LinePlotEntry] = []
        for (_, entries) in weeklyGrouping(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let weekExpensePoint = LinePlotEntry(xValueType: "Week", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            weeklyExpenseList.append(weekExpensePoint)
        }
        return weeklyExpenseList.sorted(using: KeyPathComparator(\.xValue))
    }

    private func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        var monthlyExpenseList: [LinePlotEntry] = []
        for (_, entries) in monthlyGrouping(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let monthExpensePoint = LinePlotEntry(xValueType: "Month", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            monthlyExpenseList.append(monthExpensePoint)
        }
        return monthlyExpenseList.sorted(using: KeyPathComparator(\.xValue))
    }

    func getYValueLabel(_ filter: ExpenseChartFilter, _ date: Date) -> String {
        switch filter {
        case .monthly:
            return getMonthStringFromDate(date: date)
        case .weekly:
            return getWeekStringFromDate(date: date)
        case .daily:
            return getDayStringFromDate(date: date)
        default:
            return ""
        }
    }

    private func getMonthStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }

    private func getWeekStringFromDate(date: Date) -> String {
        return "Week \(date.weekOfMonth())"
    }
    
    private func getDayStringFromDate(date: Date) -> String {
        return date.dayOfWeekString()
    }
}
