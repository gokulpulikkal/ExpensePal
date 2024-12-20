//
//  BarChartPresenter.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import SwiftData
import SwiftUI
import ExpensePalModels

struct BarChartPresenter: View {

    var filter: ExpenseChartMainFilter
    @State var viewModel = ViewModel()
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier

    @Query var expenseList: [Expense]

    @Binding var chartXSelection: String?
    @Binding var chartYSelection: Double?
    @Binding var averageYValue: Double
    @Binding var isChartEmpty: Bool

    init(
        _ filter: ExpenseChartMainFilter,
        _ chartXSelection: Binding<String?>,
        _ chartYSelection: Binding<Double?>,
        _ averageYValue: Binding<Double>,
        _ isChartEmpty: Binding<Bool>
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
        _isChartEmpty = isChartEmpty
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
        .onChange(of: localeIdentifier) {
            viewModel.localeIdentifier = localeIdentifier
        }
        .onAppear(perform: {
            // sometimes only the chart component only getting reloaded.
            // This update is needed for the first time update. Without any filter change
            updateAverageYValue()
            isChartEmpty = expenseList.count == 0
        })
    }
    
    private func updateAverageYValue()  {
        averageYValue = viewModel.averageSpending
    }
}

#if DEBUG
#Preview {
    BarChartPresenter(.Year, .constant(""), .constant(0), .constant(0), .constant(false))
        .modelContainer(previewContainer)
}
#endif
