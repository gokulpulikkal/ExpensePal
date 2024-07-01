//
//  HomeChartViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 18/06/24.
//

import Observation
import SwiftUI

class HomeChartViewModel {
    var monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter
    }()

    var sortedMonthlyExpensePlots: [LinePlotEntry]?
    var monthlyGrouping: [String: [Expense]]?

    var weeklyGroupingDict: [String: [Expense]]?
    var sortedWeeklyExpensePlots: [LinePlotEntry]?

    var dailyGroupingDict: [String: [Expense]]?
    var sortedDailyExpensePlots: [LinePlotEntry]?

    // Corrected
    func dailyGroupingForCurrentWeek(_ allEntries: [Expense]) -> [String: [Expense]] {
        if let dailyGroupingDict = dailyGroupingDict {
            return dailyGroupingDict
        }
        let now = Date()
        let currentWeekEntries = allEntries.filter { $0.date >= now.startOfWeek() ?? now }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // Full day name
        // Grouping expenses by day of the week
        dailyGroupingDict = Dictionary(grouping: currentWeekEntries, by: { expense in
            dateFormatter.string(from: expense.date)
        })
        return dailyGroupingDict!
    }

    func weeklyGroupingForCurrentMonth(_ allEntries: [Expense]) -> [String: [Expense]] {
        let now = Date.now
        let startOfMonth = now.startOfMonth() ?? now
        let endOfMonth = now.endOfMonth() ?? now
        let currentMonthEntries = allEntries.filter({ $0.date >= startOfMonth})

        // Grouping expenses by week of the month
        weeklyGroupingDict = Dictionary(grouping: currentMonthEntries, by: { expense in
            "\(expense.date.weekOfMonth())"
        })
        return weeklyGroupingDict!
    }

    func monthlyGrouping(_ allEntries: [Expense]) -> [String: [Expense]] {
        monthlyGrouping = Dictionary(grouping: allEntries, by: { monthDateFormatter.string(from: $0.date) })
        return monthlyGrouping!
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

    func isDataPointIsLast(_ filter: ExpenseChartFilter, _ dataPoint: LinePlotEntry) -> Bool {
        switch filter {
        case .daily:
            if let sortedDailyExpensePlots = sortedDailyExpensePlots {
                return dataPoint.id == sortedDailyExpensePlots.last?.id
            }
        case .weekly:
            if let sortedWeeklyExpensePlots = sortedWeeklyExpensePlots {
                return dataPoint.id == sortedWeeklyExpensePlots.last?.id
            }
        case .monthly:
            if let sortedMonthlyExpensePlots = sortedMonthlyExpensePlots {
                return dataPoint.id == sortedMonthlyExpensePlots.last?.id
            }
        default:
            return true
        }

        return false
    }

    func closestDatePointInEntry(_ filter: ExpenseChartFilter, to date: Date) -> Date? {
        //TODO: This is inefficient way.
        var entries: [LinePlotEntry]?
        switch filter {
        case .daily:
            entries = sortedDailyExpensePlots
        case .weekly:
            entries = sortedWeeklyExpensePlots
        case .monthly:
            entries = sortedMonthlyExpensePlots
        default:
            entries = []
        }
        if let entries = entries, !entries.isEmpty {
            var closestEntry = entries[0]
            var smallestDifference = abs(closestEntry.xValue.timeIntervalSince(date))

            for entry in entries.dropFirst() {
                let difference = abs(entry.xValue.timeIntervalSince(date))
                if difference < smallestDifference {
                    closestEntry = entry
                    smallestDifference = difference
                }
            }

            return closestEntry.xValue
        }
        return nil
    }

    func getXAxisUnit(_ filter: ExpenseChartFilter) -> Calendar.Component {
        switch filter {
        case .monthly:
            return .month
        case .weekly:
            return .weekOfMonth
        case .daily:
            return .day
        default:
            return .month
        }
    }

    // Corrected
    private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        if let sortedDailyExpensePlots = sortedDailyExpensePlots {
            return sortedDailyExpensePlots
        }
        var dailyExpenseList: [LinePlotEntry] = []
        for (_, entries) in dailyGroupingForCurrentWeek(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let dayExpensePoint = LinePlotEntry(xValueType: "Day", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            dailyExpenseList.append(dayExpensePoint)
        }
        sortedDailyExpensePlots = dailyExpenseList.sorted(using: KeyPathComparator(\.xValue))
        return sortedDailyExpensePlots!
    }

    private func weekWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        if let sortedWeeklyExpensePlots = sortedWeeklyExpensePlots {
            return sortedWeeklyExpensePlots
        }
        var weeklyExpenseList: [LinePlotEntry] = []
        for (_, entries) in weeklyGroupingForCurrentMonth(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let weekExpensePoint = LinePlotEntry(xValueType: "Week", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            weeklyExpenseList.append(weekExpensePoint)
        }
        sortedWeeklyExpensePlots = weeklyExpenseList.sorted(using: KeyPathComparator(\.xValue))
        return sortedWeeklyExpensePlots!
    }

    private func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        if let sortedMonthlyExpensePlots = sortedMonthlyExpensePlots {
            return sortedMonthlyExpensePlots
        }
        var monthlyExpenseList: [LinePlotEntry] = []
        for (_, entries) in monthlyGrouping(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let monthExpensePoint = LinePlotEntry(xValueType: "Month", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            monthlyExpenseList.append(monthExpensePoint)
        }
        sortedMonthlyExpensePlots = monthlyExpenseList.sorted(using: KeyPathComparator(\.xValue))
        return sortedMonthlyExpensePlots ?? []
    }

    func getXValueLabel(_ filter: ExpenseChartFilter, _ date: Date) -> String {
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

    func getExpenseForChartDataPoint(_ selectedChartPoint: Date?, _ filter: ExpenseChartFilter, _ allEntries: [Expense]) -> Double {
        switch filter {
        case .monthly:
            if let selectedChartPoint {
                return monthlyGrouping(allEntries)[monthDateFormatter.string(from: selectedChartPoint)]?.reduce(0, { $0 + $1.cost }) ?? 0
            } else {
                let monthWiseLastExpense = monthWiseExpense(allEntries).last
                return monthWiseLastExpense?.yValue ?? 0
            }
        case .weekly:
            if let selectedChartPoint {
                return weeklyGroupingForCurrentMonth(allEntries)["Week \(selectedChartPoint.weekOfMonth())"]?.reduce(0, { $0 + $1.cost }) ?? 0
            } else {
                let weekWiseLastExpense = weekWiseExpense(allEntries).last
                return weekWiseLastExpense?.yValue ?? 0
            }
        case .daily:
            if let selectedChartPoint {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dailyGroupingForCurrentWeek(allEntries)[dateFormatter.string(from: selectedChartPoint)]?.reduce(0, { $0 + $1.cost }) ?? 0
            } else {
                let dayWiseLastExpense = dailyWiseExpense(allEntries).last
                return dayWiseLastExpense?.yValue ?? 0
            }
        default:
            return 0
        }
    }
    
    func getXAxisValues(filter: ExpenseChartFilter) -> [Date] {
        //TODO: This is inefficient way.
        switch filter {
        case .daily:
            if let sortedDailyExpensePlots {
                return sortedDailyExpensePlots.map{ $0.xValue }
            }
            return []
        case .weekly:
            if let sortedWeeklyExpensePlots {
                return sortedWeeklyExpensePlots.map{ $0.xValue }
            }
            return []
        case .monthly:
            if let sortedMonthlyExpensePlots {
                return sortedMonthlyExpensePlots.map{ $0.xValue }
            }
            return []
        default:
            return []
        }
    }
}
