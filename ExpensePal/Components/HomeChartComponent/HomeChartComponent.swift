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
            Text(expenseList.reduce(0) { $0 + $1.cost }, format: .currency(code: "USD"))
                .bold()
                .font(.largeTitle)

            Chart(viewModel.getExpenseChartDataPoints(filter, expenseList)) { dataPoint in
                LineMark(x: .value(dataPoint.xValueType, viewModel.getYValueLabel(filter, dataPoint.xValue)), y: .value(dataPoint.yValueType, dataPoint.yValue))
                    .symbol(symbol: {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 17)
                            .background(Color(AppColors.primaryBackground.rawValue))
                            .clipShape(Circle())

                    })
            }
            .chartYAxis(.hidden)
            .aspectRatio(1.5, contentMode: .fit)
            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        }
    }
}

#Preview {
    HomeChartComponent(.weekly)
        .modelContainer(previewContainer)
}
