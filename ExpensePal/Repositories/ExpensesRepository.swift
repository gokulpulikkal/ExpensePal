//
//  ExpensesRepository.swift
//  ExpensePal
//
//  Created by Gokul P on 12/25/24.
//

import ExpensePalModels
import Foundation

class ExpensesRepository: ExpensesRepositoryProtocol {

    private let currencyConverter: CurrencyConverterProtocol

    init(currencyConverter: CurrencyConverterProtocol = CurrencyConverter.shared) {
        self.currencyConverter = currencyConverter
    }

    func getMonthlyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double) {
        var expensesByMonth: [Date: [Expense]] = [:]
        let calendar = Calendar.current
        let currentDate = Date()
        let thisMonth = calendar.component(.month, from: currentDate)

        guard let firstDayOfYear = currentDate.firstDayOfYear() else {
            return ([], 0)
        }

        // Initialize months
        for monthOffset in 0..<thisMonth {
            if let month = calendar.date(byAdding: .month, value: monthOffset, to: firstDayOfYear) {
                expensesByMonth[month] = []
            }
        }

        // Group expenses by month
        for expense in allEntries {
            if let startOfMonth = expense.date.startOfMonth() {
                expensesByMonth[startOfMonth]?.append(expense)
            }
        }

        // Fill empty months
        for month in expensesByMonth.keys where expensesByMonth[month]?.isEmpty ?? true {
            expensesByMonth[month] = [Expense(emoji: "", title: "", cost: 0, date: month)]
        }

        return calculatePlotEntries(from: expensesByMonth, localeIdentifier: localeIdentifier, xValueType: "Month")
    }

    func getDailyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double) {
        var expensesByDay: [Date: [Expense]] = [:]
        let calendar = Calendar.current
        let currentDate = Date()

        // Get start of current week
        let startOfWeek = calendar.date(
            byAdding: .day,
            value: -(calendar.component(.weekday, from: currentDate) - calendar.firstWeekday),
            to: calendar.startOfDay(for: currentDate)
        )!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        // Initialize all 7 days of the week
        for dayOffset in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                expensesByDay[day] = []
            }
        }

        // Group expenses by day (only include expenses within the current week)
        for expense in allEntries {
            let date = calendar.startOfDay(for: expense.date)
            // Only include expenses that fall within the current week
            if date >= startOfWeek, date <= endOfWeek {
                expensesByDay[date, default: []].append(expense)
            }
        }

        // Fill empty days
        for day in expensesByDay.keys where expensesByDay[day]?.isEmpty ?? true {
            expensesByDay[day] = [Expense(emoji: "", title: "", cost: 0, date: day)]
        }

        return calculatePlotEntries(from: expensesByDay, localeIdentifier: localeIdentifier, xValueType: "Day")
    }

    func getYearlyExpenses(_ allEntries: [Expense], localeIdentifier: String?) -> ([LinePlotEntry], Double) {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let startOfThisYear = currentDate.firstDayOfYear() else {
            return ([], 0)
        }

        var expensesByYear: [Date: [Expense]] = [:]
        let thisYear = currentDate.year()

        // If there are entries, find the earliest year
        let startingYear = allEntries.min { $0.date < $1.date }?.date.year() ?? thisYear

        // Initialize years from earliest year up to current year
        for year in min(startingYear, thisYear)...max(startingYear, thisYear) {
            if let yearDate = calendar.date(from: DateComponents(year: year)) {
                expensesByYear[yearDate] = []
            }
        }

        // Group expenses by year
        for expense in allEntries {
            if let date = expense.date.firstDayOfYear(),
               date >= expensesByYear.keys.min() ?? startOfThisYear,
               date <= startOfThisYear
            {
                expensesByYear[date, default: []].append(expense)
            }
        }

        // Fill empty years
        for year in expensesByYear.keys where expensesByYear[year]?.isEmpty ?? true {
            expensesByYear[year] = [Expense(emoji: "", title: "", cost: 0, date: year)]
        }

        return calculatePlotEntries(from: expensesByYear, localeIdentifier: localeIdentifier, xValueType: "Year")
    }

    private func calculatePlotEntries(
        from expenses: [Date: [Expense]],
        localeIdentifier: String?,
        xValueType: String
    ) -> ([LinePlotEntry], Double) {
        var linePlotList: [LinePlotEntry] = []
        var totalForAverage: Double = 0

        for (date, dateExpenses) in expenses {
            let totalAmount = dateExpenses.reduce(0) {
                let convertedVal = currencyConverter.convert(
                    $1.cost,
                    valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD),
                    outputCurrency: Locales(localeIdentifier: localeIdentifier ?? "en_US")?.currency ?? .USD
                ) ?? 0
                return $0 + convertedVal
            }

            totalForAverage += totalAmount
            linePlotList.append(LinePlotEntry(
                xValueType: xValueType,
                yValueType: "Expense",
                xValue: date,
                yValue: totalAmount
            ))
        }

        let averageSpending = expenses.isEmpty ? 0 : totalForAverage / Double(expenses.count)
        return (linePlotList.sorted(using: KeyPathComparator(\.xValue)), averageSpending)
    }
}
