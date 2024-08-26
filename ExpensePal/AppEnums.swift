//
//  AppEnums.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import Foundation

enum AppColors: String {
    case primaryAccent = "PrimaryAccentColour"
    case primaryBackground = "PrimaryBGColour"
}

enum ExpenseChartFilter: String, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    case yearly

    var id: Self { self }

    var description: String {
        switch self {
        case .daily: "This week"
        case .weekly: "This month"
        case .monthly: "This Year"
        case .yearly: "Yearly"
        }
    }
}

enum ExpenseSearchFilter: String, CaseIterable, Identifiable {
    case thisWeek
    case thisMonth
    case thisYear
    case all

    var id: Self { self }

    var description: String {
        switch self {
        case .thisWeek: "This Week"
        case .thisMonth: "This Month"
        case .thisYear: "This Year"
        case .all: "All expenses"
        }
    }

    var fetchFilter: ExpenseListFetchFilters {
        switch self {
        case .thisWeek: .thisWeek
        case .thisMonth: .thisMonth
        case .thisYear: .thisYear
        case .all: .prevYears
        }
    }
}

enum ExpenseListFetchFilters {
    case thisWeek
    case thisMonth
    case thisYear
    case prevYears
}

enum ExpenseChartMainFilter: String, CaseIterable, Identifiable {
    case Week
    case Month
    case Year

    var id: Self { self }

    var description: String {
        switch self {
        case .Week: "Week"
        case .Month: "Month"
        case .Year: "Year"
        }
    }
}

enum iPadTabs: String, CaseIterable, Identifiable {

    case DashBoard = "house.circle"
    case ExpenseList = "list.bullet.circle"
    case ExpenseChart = "chart.pie"
    case Settings = "gearshape"
    
    var id: String {
        return rawValue
    }

    var title: String {
        switch self {
        case .DashBoard:
            "Dashboard"
        case .ExpenseList:
            "Expense List"
        case .ExpenseChart:
            "Expense Chart"
        case .Settings:
            "Settings"
        }
    }
}
