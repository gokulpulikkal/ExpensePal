//
//  MockData.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Foundation

struct MockData {
    static let mockExpenseList: [Expense] = [
            Expense(emoji: "🐶", title: "Pet care", subTitle: "Petco", cost: 179.0, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
            Expense(emoji: "🍔", title: "Food", subTitle: "McDonald's", cost: 15.5, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
            Expense(emoji: "🛍️", title: "Shopping", subTitle: "Mall", cost: 230.0, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            Expense(emoji: "⛽️", title: "Gas", subTitle: "Shell", cost: 60.0, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
            Expense(emoji: "☕️", title: "Coffee", subTitle: "Starbucks", cost: 5.75, date: Calendar.current.date(byAdding: .hour, value: -6, to: Date())!),
            Expense(emoji: "🎬", title: "Entertainment", subTitle: "Cinema", cost: 45.0, date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!),
            Expense(emoji: "📚", title: "Books", subTitle: "Bookstore", cost: 120.0, date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!),
            Expense(emoji: "🏋️", title: "Gym", subTitle: "Fitness Center", cost: 75.0, date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!),
            Expense(emoji: "🧳", title: "Travel", subTitle: "Airline", cost: 450.0, date: Calendar.current.date(byAdding: .day, value: -21, to: Date())!),
            Expense(emoji: "🍕", title: "Dinner", subTitle: "Pizzeria", cost: 30.0, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)
        ]
}
