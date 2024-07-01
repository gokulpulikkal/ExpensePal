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

extension HomeChartRefactored {
    class ViewModel {
        
        var maxYRange: Int = 0
        var minYRange: Int = 0
        
        func getExpenseChartDataPoints(_ filter: ExpenseChartFilter, _ allEntries: [Expense]) -> [LinePlot] {
            switch filter {
//            case .monthly:
//                return monthWiseExpense(allEntries)
//            case .weekly:
//                return weekWiseExpense(allEntries)
            case .daily:
                return dailyWiseExpense(allEntries)
            default:
                return []
            }
        }

        func formatDateToDayOfWeek(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE" // "EEEE" gives the full name of the day
            return dateFormatter.string(from: date)
        }

        // Helper function to get a date for a specific day offset from today
        func getDate(daysOffset: Int) -> Date {
            return Calendar.current.date(byAdding: .day, value: -daysOffset, to: Date())!
        }

        private func dailyWiseExpense(_ allEntries: [Expense]) -> [LinePlot] {
            
            let expenses: [Expense] = [
                Expense(emoji: "🍎", title: "Groceries", subTitle: "Supermarket", cost: 50.0, date: getDate(daysOffset: 0)),
                Expense(emoji: "☕️", title: "Coffee", subTitle: "Cafe", cost: 5.0, date: getDate(daysOffset: 0)),
                Expense(emoji: "🍕", title: "Lunch", subTitle: "Pizza Place", cost: 20.0, date: getDate(daysOffset: 1)),
                Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 30.0, date: getDate(daysOffset: 2)),
                Expense(emoji: "🎬", title: "Movie", subTitle: "Cinema", cost: 15.0, date: getDate(daysOffset: 2)),
                Expense(emoji: "🏋️‍♂️", title: "Gym", subTitle: "Fitness Club", cost: 40.0, date: getDate(daysOffset: 3)),
                Expense(emoji: "🍔", title: "Dinner", subTitle: "Restaurant", cost: 25.0, date: getDate(daysOffset: 3))
            ]
            // From here to
            var expensesByDay: [Date: [Expense]] = [:]

            // Get the current calendar and the current date
            let calendar = Calendar.current
            let currentDate = Date()

            // Determine the start of the week
            let thisWeekDay = calendar.component(.weekday, from: currentDate)
//            let startOfTheWeekDay = calendar.firstWeekday
            let startOfWeek = calendar.date(byAdding: .day, value: -(thisWeekDay - calendar.firstWeekday), to: calendar.startOfDay(for: currentDate))!
            
            for dayOffset in 0 ..< thisWeekDay {
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
                linePlotList.append(LinePlot(xValueType: "Day", yValueType: "Expense", xValue: date, yValue: totalAmount))
                
            }
            
            minYRange = minExpense
            maxYRange = maxExpense
            
            return linePlotList.sorted(using: KeyPathComparator(\.xValue))
        }
    }
}
