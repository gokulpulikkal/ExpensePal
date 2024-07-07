//
//  BarChartPresenter.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import SwiftData
import SwiftUI

struct BarChartPresenter: View {

    var filter: ExpenseChartMainFilter
    let viewModel = ViewModel()

    @Query var expenseList: [Expense]

    @Binding var chartXSelection: String?
    @Binding var chartYSelection: Double?
    @Binding var averageYValue: Double

    init(
        _ filter: ExpenseChartMainFilter,
        _ chartXSelection: Binding<String?>,
        _ chartYSelection: Binding<Double?>,
        _ averageYValue: Binding<Double>
    ) {
        switch filter {
        case .Week:
            // This week expenses
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisWeek))
        case .Month:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisYear))
        case .Year:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.prevYears))
        }
        self.filter = filter
        _chartXSelection = chartXSelection
        _chartYSelection = chartYSelection
        _averageYValue = averageYValue
    }

    var body: some View {
        ChartComponentView(
            filter: filter,
            data: viewModel.getExpenseChartDataPoints(filter, expenseList),
            chartXSelection: $chartXSelection,
            chartYSelection: $chartYSelection
        )
        .frame(height: 300)
        .onChange(of: filter) {
            updateAverageYValue()
        }
        .onAppear(perform: {
            // sometimes only the chart component only getting reloaded.
            // This update is needed for the first time update. Without any filter change
            updateAverageYValue()
        })
    }
    
    private func updateAverageYValue()  {
        averageYValue = viewModel.averageSpending
    }
}

#Preview {
    BarChartPresenter(.Year, .constant(""), .constant(0), .constant(0))
        .modelContainer(previewContainer)
}
