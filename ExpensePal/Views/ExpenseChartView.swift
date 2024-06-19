//
//  ExpenseChartView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    var body: some View {
        ZStack {
            Chart {
                BarMark(x: .value("Month", "May"), y: .value("Expense", 100))
                BarMark(x: .value("Month", "June"), y: .value("Expense", 50))
                BarMark(x: .value("Month", "July"), y: .value("Expense", 20))
            }
        }
    }
}

#Preview {
    ExpenseChartView()
}
