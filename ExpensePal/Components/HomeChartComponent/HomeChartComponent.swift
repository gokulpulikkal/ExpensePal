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
    @Query(filter: Expense.currentYearPredicate()) var expenseList: [Expense]
    let viewModel = HomeChartViewModel()

    var body: some View {
        VStack {
            Text(expenseList.reduce(0) { $0 + $1.cost }, format: .currency(code: "USD"))
                .bold()
                .font(.largeTitle)
            Chart(viewModel.monthWiseExpense(expenseList)) { dataPoint in
                LineMark(x: .value("Month", viewModel.getMonthStringFromDate(date: dataPoint.xValue)), y: .value("Expense", dataPoint.yValue))
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
            .padding()
        }
    }
}

#Preview {
    HomeChartComponent()
        .modelContainer(previewContainer)
}
