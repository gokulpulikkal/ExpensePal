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

    @State var persistentSelectedDate: Date?

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
            Text(viewModel.getExpenseForChartDataPoint(persistentSelectedDate, filter, expenseList), format: .currency(code: "USD"))
                .bold()
                .font(.largeTitle)
                .animation(.easeInOut, value: persistentSelectedDate?.dayOfWeekString())
            chart
        }
        .onChange(of: selectedDateInChart, {
            if selectedDateInChart != nil {
                persistentSelectedDate = viewModel.closestDatePointInEntry(filter, to: selectedDateInChart!)
            }
        })
        .onChange(of: filter) {
            persistentSelectedDate = nil
        }
    }

    var chart: some View {
        Chart(viewModel.getExpenseChartDataPoints(filter, expenseList)) { dataPoint in
            LineMark(x: .value(dataPoint.xValueType, dataPoint.xValue, unit: viewModel.getXAxisUnit(filter)), y: .value(dataPoint.yValueType, dataPoint.yValue))
                .symbol(symbol: {
                    if (persistentSelectedDate != nil && Calendar.current.isDate(persistentSelectedDate!, equalTo: dataPoint.xValue, toGranularity: viewModel.getXAxisUnit(filter))) ||
                        viewModel.isDataPointIsLast(filter, dataPoint) && persistentSelectedDate == nil {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 17)
                            .background(Color(AppColors.primaryBackground.rawValue))
                            .clipShape(Circle())
                    }
                })
                .interpolationMethod(.catmullRom)
            if let selectedDateInChart {
                // Rule mark is hidden now.
                // Only the annotation is what shown to the user
                RuleMark(
                    x: .value("Selected", selectedDateInChart, unit: .day)
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .opacity(0)
                .annotation(
                    position: .bottom, spacing: 0,
                    overflowResolution: .init(
                        x: .fit(to: .chart),
                        y: .disabled
                    )
                ) {
                    Text(selectedDateInChart, style: .date)
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                }
            }
        }
        .chartYScale(range: .plotDimension(startPadding: 10, endPadding: 10))
        .chartXScale(range: .plotDimension(startPadding: 10, endPadding: 10))
        .chartXSelection(value: $selectedDateInChart)
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(initialX: selectedDateInChart ?? Date.now)
        .chartYAxis(.hidden)
//        .chartXAxis(.hidden)
        .aspectRatio(1.5, contentMode: .fit)
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .animation(Animation.easeInOut(duration: 0.1), value: filter)
    }
}

#Preview {
    HomeChartComponent(.daily)
        .modelContainer(previewContainer)
}
