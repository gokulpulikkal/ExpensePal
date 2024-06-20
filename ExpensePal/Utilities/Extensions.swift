//
//  Extensions.swift
//  ExpensePal
//
//  Created by Gokul P on 19/06/24.
//

import Foundation

extension Date {
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }

    func firstDayOfYear(using calendar: Calendar = .current) -> Date? {
        DateComponents(calendar: calendar, year: year(using: calendar)).date
    }

    func startOfMonth() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }

    func endOfMonth() -> Date? {
        let calendar = Calendar.current
        if let startOfMonth = startOfMonth() {
            var components = DateComponents()
            components.month = 1
            components.day = -1
            return calendar.date(byAdding: components, to: startOfMonth)
        }
        return nil
    }

    func weekOfMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfMonth, from: self)
    }

    func startOfWeek() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = calendar.firstWeekday
        return calendar.date(from: components)
    }

    func endOfWeek() -> Date? {
        let calendar = Calendar.current
        if let startOfWeek = startOfWeek() {
            var components = DateComponents()
            components.day = 6
            return calendar.date(byAdding: components, to: startOfWeek)
        }
        return nil
    }

    func dayOfWeekString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full day name
        return dateFormatter.string(from: self)
    }
}
