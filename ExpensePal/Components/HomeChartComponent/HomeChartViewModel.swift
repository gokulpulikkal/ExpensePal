//
//  HomeChartViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 18/06/24.
//

import SwiftUI
import Observation

@Observable class HomeChartViewModel {
    
    func monthlyGrouping(_ allEntries: [Expense]) -> [String : [Expense]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        for expense in allEntries {
            print("expense name : \(expense.title)")
            print(dateFormatter.string(from: expense.date))
        }
        return Dictionary(grouping: allEntries, by: {dateFormatter.string(from: $0.date)})
    }
    
    func monthWiseExpense(_ allEntries: [Expense]) -> [LinePlotEntry] {
        var monthlyExpenseList: [LinePlotEntry] = []
        
        for (_, entries) in monthlyGrouping(allEntries) {
            let totalCost = entries.reduce(0) { $0 + $1.cost }
            let monthExpensePoint = LinePlotEntry(xValueType: "Month", yValueType: "Expense", xValue: entries[0].date, yValue: totalCost)
            monthlyExpenseList.append(monthExpensePoint)
        }
        return monthlyExpenseList.sorted(using: KeyPathComparator(\.xValue))
    }
    
    func getMonthStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
}
