//
//  HomeChartComponent.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Charts
import SwiftData
import SwiftUI

struct HomeChartComponent: View {
    @Query var expenseList: [Expense]
    @State private var selectedIndex: Int? = nil
    @State var selectedDateInChart: Date?
    let viewModel = HomeChartViewModel()
    var filter: ExpenseChartFilter

    init(_ filter: ExpenseChartFilter) {
        var predicate: Predicate<Expense>?
        switch filter {
        case .yearly:
            predicate = nil
        default:
            predicate = Expense.currentYearPredicate()
        }
        self.filter = filter
        if let predicate {
            _expenseList = Query(filter: predicate)
        }
    }

    var body: some View {
        VStack {
            Text(0, format: .currency(code: "USD"))
                .bold()
                .font(.largeTitle)
            chart
            Text(selectedDateInChart ?? Date.now, style: .date)
        }
    }

    var chart: some View {
        Chart(viewModel.getExpenseChartDataPoints(filter, expenseList)) { dataPoint in
            LineMark(x: .value(dataPoint.xValueType, dataPoint.xValue, unit: viewModel.getXAxisUnit(filter)), y: .value(dataPoint.yValueType, dataPoint.yValue))
                .symbol(symbol: {
                    if (selectedDateInChart != nil && Calendar.current.isDate(selectedDateInChart!, equalTo: dataPoint.xValue, toGranularity: viewModel.getXAxisUnit(filter))) {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 17)
                            .background(Color(AppColors.primaryBackground.rawValue))
                            .clipShape(Circle())
                    }
                })
                .interpolationMethod(.catmullRom)
        }
        .chartXSelection(value: $selectedDateInChart)
        .chartYAxis(.hidden)
        .aspectRatio(1.5, contentMode: .fit)
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .animation(Animation.easeInOut(duration: 0.1), value: filter)
    }
}

#Preview {
    HomeChartComponent(.weekly)
        .modelContainer(previewContainer)
}
