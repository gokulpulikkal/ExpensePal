//
//  BarChartPresenter.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import SwiftUI
import SwiftData

struct BarChartPresenter: View {
    
    var filter: ExpenseChartMainFilter
    @Query var expenseList: [Expense]
    let viewModel = ViewModel()
    
    init(_ filter: ExpenseChartMainFilter) {
        switch filter {
        case .Week:
            // This week expenses
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisWeek))
        case .Month:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisYear))
        case .Year:
            _expenseList = Query(Expense.getFetchDescriptorForFilter(.thisYear))
        }
        self.filter = filter
    }
    
    var body: some View {
        ChartComponentView(filter: filter, data: viewModel.getExpenseChartDataPoints(filter, expenseList))
            .frame(width: .infinity, height: 300)
            .padding()
    }
}

#Preview {
    BarChartPresenter(.Month)
        .modelContainer(previewContainer)
}
