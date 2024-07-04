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
//                    if (persistentSelectedDate != nil && Calendar.current.isDate(persistentSelectedDate!, equalTo: dataPoint.xValue, toGranularity: viewModel.getXAxisUnit(filter))) ||
//                        viewModel.isDataPointIsLast(filter, dataPoint) && persistentSelectedDate == nil {
                    Circle()
                        .stroke(lineWidth: 5)
                        .frame(width: 17)
                        .background(Color(AppColors.primaryBackground.rawValue))
                        .clipShape(Circle())
//                    }
                })
//                .interpolationMethod(.catmullRom)
            if let selectedDateInChart {
                // Rule mark is hidden now.
                // Only the annotation is what shown to the user
                RuleMark(
                    x: .value("Selected", selectedDateInChart, unit: .day)
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .opacity(1)
                .annotation(
                    position: .overlay, spacing: 0,
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
        .chartXAxis {
//             For daily
//            AxisMarks(values: .stride(by: .day)) { _ in
//                AxisValueLabel(format: .dateTime.day(), centered: true)
//                AxisGridLine()
//                AxisTick()
//            }

//             For Monthly
            AxisMarks(values: viewModel.getXAxisValues(filter: filter)) { value in
                
                if let date = value.as(Date.self) {
                    AxisValueLabel(format: .dateTime.week(.weekOfMonth), centered: true)
                }
//                AxisValueLabel(format: .dateTime.day(), centered: true)
                AxisGridLine()
                AxisTick()
            }
        }
//        .chartYScale(range: .plotDimension(startPadding: 10, endPadding: 10))
//        .chartXScale(range: .plotDimension(startPadding: 10, endPadding: 10))
        .chartXSelection(value: $selectedDateInChart)
//        .chartScrollableAxes(.horizontal)
//        .chartScrollPosition(initialX: Date.now)
        .chartYAxis(.hidden)
//        .chartXAxis(.hidden)

        .aspectRatio(1.5, contentMode: .fit)
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .animation(Animation.easeInOut(duration: 0.1), value: filter)
    }
}

#Preview {
    HomeChartComponent(.monthly)
        .modelContainer(previewContainer)
}
