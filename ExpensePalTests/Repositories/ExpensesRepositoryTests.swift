//
//  ExpensesRepositoryTests.swift
//  ExpensePalTests
//
//  Created by Gokul P on 12/25/24.
//

import ExpensePalModels
import Foundation
import Testing
@testable import ExpensePal

struct ExpensesRepositoryTests {
    /// Test repository with mock converter
    let repository = ExpensesRepository(currencyConverter: CurrencyConverterMock())

    /// Use mock data from JSON
    let testExpenses = MockData().getMockDataFromJSON()

    @Test
    func testMonthlyExpenses() async throws {
        let (entries, average) = repository.getMonthlyExpenses(testExpenses, localeIdentifier: "en_US")

        // Check if we got entries
        #expect(entries.isEmpty == false)

        // filter the test expense to only have this year expenses
        let filteredExpenses = testExpenses
            .filter { Calendar.current.component(.year, from: $0.date) >= Calendar.current.component(
                .year,
                from: Date()
            ) }

        let totalExpected = filteredExpenses.reduce(0) { $0 + $1.cost }.rounded()
        let totalReturned = entries.reduce(0) { $0 + $1.yValue }.rounded()

        #expect(totalReturned == totalExpected)
        #expect(average.rounded() == (totalExpected / 12).rounded())
    }

    @Test
    func testDailyExpenses() async throws {
        let (entries, average) = repository.getDailyExpenses(testExpenses, localeIdentifier: "en_US")

        // Check if we got entries
        #expect(entries.isEmpty == false)

        // Filter expenses for the current week only
        let currentDate = Date()
        let calendar = Calendar.current

        let filteredExpenses = testExpenses.filter { expense in
            calendar.isDate(expense.date, equalTo: currentDate, toGranularity: .weekOfYear)
        }

        let totalExpected = filteredExpenses.reduce(0) { $0 + $1.cost }.rounded()
        let totalReturned = entries.reduce(0) { $0 + $1.yValue }.rounded()

        #expect(totalReturned == totalExpected)
        #expect(average.rounded() == (totalExpected / 7).rounded())
    }

    @Test
    func testYearlyExpenses() async throws {
        let (entries, average) = repository.getYearlyExpenses(testExpenses, localeIdentifier: "en_US")

        // Check if we got entries
        #expect(entries.isEmpty == false)

        let totalExpected = testExpenses.reduce(0) { $0 + $1.cost }.rounded()
        let totalReturned = entries.reduce(0) { $0 + $1.yValue }.rounded()

        #expect(totalReturned == totalExpected)
        #expect(average.rounded() == (totalExpected / Double(entries.count)).rounded())
    }

    @Test
    func testEmptyExpenses() async throws {
        let emptyExpenses: [Expense] = []

        let (monthlyEntries, monthlyAvg) = repository.getMonthlyExpenses(emptyExpenses, localeIdentifier: "en_US")
        #expect(monthlyAvg == 0)
        #expect(monthlyEntries.count == 12) // Should have 12 months with 0 values

        let (dailyEntries, dailyAvg) = repository.getDailyExpenses(emptyExpenses, localeIdentifier: "en_US")
        #expect(dailyAvg == 0)
        #expect(dailyEntries.count == 7) // Should have 7 days with 0 values

        let (yearlyEntries, yearlyAvg) = repository.getYearlyExpenses(emptyExpenses, localeIdentifier: "en_US")
        #expect(yearlyAvg == 0)
        #expect(!yearlyEntries.isEmpty) // Should have current year with 0 value
    }

    @Test
    func testFutureExpenses() async throws {
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let futureExpense = Expense(emoji: "💰", title: "Future", cost: 100, date: futureDate)
        let expenses = [futureExpense]

        let (entries, _) = repository.getYearlyExpenses(expenses, localeIdentifier: "en_US")
        let hasCurrentYear = entries.contains { entry in
            Calendar.current.component(.year, from: entry.xValue) == Calendar.current.component(.year, from: Date())
        }
        #expect(hasCurrentYear)
    }

    @Test
    func testDifferentLocales() async throws {
        let expense = Expense(emoji: "🍕", title: "Pizza", cost: 100, date: Date(), locale: "fr_FR")
        let expenses = [expense]

        let (entriesUSD, _) = repository.getMonthlyExpenses(expenses, localeIdentifier: "en_US")
        let (entriesEUR, _) = repository.getMonthlyExpenses(expenses, localeIdentifier: "fr_FR")

        // current mock for currency converter is returning the same value for all currencies
        #expect(entriesUSD.first?.yValue == entriesEUR.first?.yValue)
    }

    @Test
    func testWeekBoundaries() async throws {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(
            byAdding: .day,
            value: -(calendar.component(.weekday, from: today) - calendar.firstWeekday),
            to: calendar.startOfDay(for: today)
        )!
        
        let outsideWeek = calendar.date(byAdding: .day, value: -1, to: startOfWeek)!

        let expenseInWeek = Expense(emoji: "📱", title: "In Week", cost: 100, date: startOfWeek)
        let expenseOutsideWeek = Expense(emoji: "📱", title: "Outside Week", cost: 100, date: outsideWeek)

        let expenses = [expenseInWeek, expenseOutsideWeek]
        let (entries, _) = repository.getDailyExpenses(expenses, localeIdentifier: "en_US")

        let totalValue = entries.reduce(0) { $0 + $1.yValue }
        #expect(totalValue == 100) // Only the expense within the week should be counted
    }

}
