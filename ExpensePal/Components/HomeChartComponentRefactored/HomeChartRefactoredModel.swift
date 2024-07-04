//
//  HomeChartRefactoredModel.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import Foundation

struct LinePlot {
    var id = UUID()
    let xValueType: String
    let yValueType: String

    let xValue: Date
    let yValue: Double
}

// MARK: - HomeChartRefactored.ViewModel

extension HomeChartRefactored {
    @Observable
    class ViewModel {

        var selectedDateStringInChart: String?
        var persistentSelectedDateString: String?
        var totalExpenseWithFilter: Double = 0

        var maxYRange = 0
        var minYRange = 0

        func shouldShowSymbolPoint(_ filter: ExpenseChartFilter, _ xValue: Date) -> Bool {
            getExpenseChartDataPointsXValue(filter, xValue) == persistentSelectedDateString
        }

        func shouldShowAnnotationPoint(_ filter: ExpenseChartFilter, _ xValue: Date) -> Bool {
            getExpenseChartDataPointsXValue(filter, xValue) == selectedDateStringInChart
        }

        func saveLastPointOfPlot(_ filter: ExpenseChartFilter, _ plotList: [LinePlot]) {
            if let lastPoint = plotList.last {
                persistentSelectedDateString = getExpenseChartDataPointsXValue(filter, lastPoint.xValue)
            }
        }

        func getExpenseChartDataPointsXValue(_ filter: ExpenseChartFilter, _ date: Date) -> String {
            switch filter {
            case .monthly:
                formatDateToMonth(date: date)
            case .weekly:
                formatDateToWeekOfMonth(date: date)
            case .daily:
                formatDateToDayOfWeek(date: date)
            default:
                ""
            }
        }

        func getExpenseChartDataPoints(_ filter: ExpenseChartFilter, _ allEntries: [Expense]) -> [LinePlot] {
            let linePlots: [LinePlot] = switch filter {
            case .monthly:
                monthWiseExpense(allEntries)
            case .weekly:
                weekWiseExpense(allEntries)
            case .daily:
                dailyWiseExpense(allEntries)
            default:
                []
            }
            if persistentSelectedDateString == nil {
                saveLastPointOfPlot(filter, linePlots)
            }
            totalExpenseWithFilter = linePlots.reduce(0) { $0 + $1.yValue }
            return linePlots
        }

        func formatDateToMonth(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM" // "EEEE" gives the full name of the day
            return dateFormatter.string(from: date)
        }

        func formatDateToDayOfWeek(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE" // "EEEE" gives the full name of the day
            return dateFormatter.string(from: date)
        }

        func formatDateToWeekOfMonth(date: Date) -> String {
            "Week \(Calendar.current.component(.weekOfMonth, from: date))"
        }

        /// Helper function to get a date for a specific day offset from today
        func getDate(daysOffset: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -daysOffset, to: Date())!
        }

        private func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
            let expenses: [Expense] = [
                Expense(
                    emoji: "🍎",
                    title: "Groceries",
                    subTitle: "Supermarket",
                    cost: 50.0,
                    date: getDate(daysOffset: 0)
                ),
                Expense(emoji: "☕️", title: "Coffee", subTitle: "Cafe", cost: 5.0, date: getDate(daysOffset: 0)),
                Expense(emoji: "🍕", title: "Lunch", subTitle: "Pizza Place", cost: 20.0, date: getDate(daysOffset: 1)),
                Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 30.0, date: getDate(daysOffset: 32)),
                Expense(emoji: "🎬", title: "Movie", subTitle: "Cinema", cost: 15.0, date: getDate(daysOffset: 33)),
                Expense(emoji: "🏋️‍♂️", title: "Gym", subTitle: "Fitness Club", cost: 40.0, date: getDate(daysOffset: 67)),
                Expense(
                    emoji: "🍎",
                    title: "Groceries",
                    subTitle: "Supermarket",
                    cost: 50.0,
                    date: getDate(daysOffset: 99)
                ),
                Expense(emoji: "☕️", title: "Coffee", subTitle: "Cafe", cost: 5.0, date: getDate(daysOffset: 10)),
                Expense(
                    emoji: "🍕",
                    title: "Lunch",
                    subTitle: "Pizza Place",
                    cost: 20.0,
                    date: getDate(daysOffset: 121)
                ),
                Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 30.0, date: getDate(daysOffset: 152)),
                Expense(emoji: "🎬", title: "Movie", subTitle: "Cinema", cost: 15.0, date: getDate(daysOffset: 12)),
                Expense(emoji: "🏋️‍♂️", title: "Gym", subTitle: "Fitness Club", cost: 40.0, date: getDate(daysOffset: 163)),
                Expense(emoji: "🍔", title: "Dinner", subTitle: "Restaurant", cost: 25.0, date: getDate(daysOffset: 177))
            ]

            for expense in expenses {
                print(Calendar.current.component(.month, from: expense.date))
            }

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

            for expense in expenses {
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

            minYRange = minExpense
            maxYRange = maxExpense

            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }

        private func weekWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
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

            var linePlotList: [LinePlot] = []
            // Print the result
            var minExpense = Int.max
            var maxExpense = 0
            for (date, expenses) in expensesByWeek {
                let totalAmount = expenses.reduce(0) { $0 + $1.cost }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlot(
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

        private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
            let expenses: [Expense] = [
                Expense(
                    emoji: "🍎",
                    title: "Groceries",
                    subTitle: "Supermarket",
                    cost: 50.0,
                    date: getDate(daysOffset: 0)
                ),
                Expense(emoji: "☕️", title: "Coffee", subTitle: "Cafe", cost: 5.0, date: getDate(daysOffset: 0)),
                Expense(emoji: "🍕", title: "Lunch", subTitle: "Pizza Place", cost: 20.0, date: getDate(daysOffset: 1)),
                Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 30.0, date: getDate(daysOffset: 32)),
                Expense(emoji: "🎬", title: "Movie", subTitle: "Cinema", cost: 15.0, date: getDate(daysOffset: 33)),
                Expense(emoji: "🏋️‍♂️", title: "Gym", subTitle: "Fitness Club", cost: 40.0, date: getDate(daysOffset: 67)),
                Expense(
                    emoji: "🍎",
                    title: "Groceries",
                    subTitle: "Supermarket",
                    cost: 50.0,
                    date: getDate(daysOffset: 99)
                ),
                Expense(emoji: "☕️", title: "Coffee", subTitle: "Cafe", cost: 5.0, date: getDate(daysOffset: 10)),
                Expense(
                    emoji: "🍕",
                    title: "Lunch",
                    subTitle: "Pizza Place",
                    cost: 20.0,
                    date: getDate(daysOffset: 121)
                ),
                Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 30.0, date: getDate(daysOffset: 152)),
                Expense(emoji: "🎬", title: "Movie", subTitle: "Cinema", cost: 15.0, date: getDate(daysOffset: 12)),
                Expense(emoji: "🏋️‍♂️", title: "Gym", subTitle: "Fitness Club", cost: 40.0, date: getDate(daysOffset: 163)),
                Expense(emoji: "🍔", title: "Dinner", subTitle: "Restaurant", cost: 25.0, date: getDate(daysOffset: 177))
            ]
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
            for expense in expenses {
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
            for (date, expenses) in expensesByDay {
                let totalAmount = expenses.reduce(0) { $0 + $1.cost }
                minExpense = min(minExpense, Int(totalAmount))
                maxExpense = max(maxExpense, Int(totalAmount))
                linePlotList.append(LinePlot(
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
