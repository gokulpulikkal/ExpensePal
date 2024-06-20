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
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
}
