//
//  HomeChartRefactored.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import SwiftData
import SwiftUI
import Charts

struct HomeChartRefactored: View {
    @Query var expenseList: [Expense]

    let viewModel = ViewModel()
    var filter: ExpenseChartFilter
    var data: [ToyShape] = [
        .init(type: "Cube", count: 5),
        .init(type: "Sphere", count: 4),
        .init(type: "Pyramid", count: 6),
    ]

    init(_ filter: ExpenseChartFilter) {
        switch filter {
        case .daily:
            // This week expenses
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisWeek))
        case .weekly:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisMonth))
        default:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisYear))
        }
        self.filter = filter
    }

    var body: some View {
        Chart {
            ForEach(viewModel.getExpenseChartDataPoints(.daily, expenseList), id: \.id) { data in
                LineMark(
                    x: .value(data.xValueType, viewModel.formatDateToDayOfWeek(date: data.xValue)),
                    y: .value(data.yValueType, data.yValue)
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: [viewModel.minYRange - 5, viewModel.maxYRange + 5])
        .padding()
    }
}

#Preview {
    HomeChartRefactored(.daily)
        .modelContainer(previewContainer)
}
