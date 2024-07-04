//
//  HomeChartRefactored.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import Charts
import SwiftData
import SwiftUI

struct HomeChartRefactored: View {
    @Query var expenseList: [Expense]
    @State var viewModel = ViewModel()

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
        Chart {
            ForEach(viewModel.getExpenseChartDataPoints(filter, expenseList), id: \.id) { data in
                LineMark(
                    x: .value(data.xValueType, viewModel.getExpenseChartDataPointsXValue(filter, data.xValue)),
                    y: .value(data.yValueType, data.yValue)
                )
                .symbol(symbol: {
                    chartSymbol(for: data.xValue)
                })
                .interpolationMethod(.catmullRom)
                if viewModel.shouldShowAnnotationPoint(filter, data.xValue) {
                    chartPointInfoView(for: data)
                }
            }
        }
        .chartXSelection(value: $viewModel.selectedDateStringInChart)
        .chartYScale(domain: [viewModel.minYRange - 20, viewModel.maxYRange + 10])
        .aspectRatio(1.5, contentMode: .fit)
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .animation(Animation.easeInOut(duration: 0.1), value: filter)
        .padding()
        .onChange(of: viewModel.selectedDateStringInChart) {
            if viewModel.selectedDateStringInChart != nil {
                viewModel.persistentSelectedDateString = viewModel.selectedDateStringInChart
            }
        }
    }

    private func chartSymbol(for xValue: Date) -> some View {
        VStack {
            if viewModel.shouldShowSymbolPoint(filter, xValue) {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 17)
                    .background(Color(AppColors.primaryBackground.rawValue))
                    .clipShape(Circle())
            }
        }
    }

    private func chartPointInfoView(for point: LinePlot) -> some ChartContent {
        PointMark(
            x: .value(point.xValueType, viewModel.getExpenseChartDataPointsXValue(filter, point.xValue)),
            y: .value(point.yValueType, point.yValue)
        )

        .annotation(
            position: .top, spacing: 0,
            overflowResolution: .init(
                x: .fit(to: .chart),
                y: .fit(to: .chart)
            )
        ) {
            VStack {
                Text(point.yValue, format: .currency(code: "USD"))
                    .bold()
                    .font(.system(size: 12))
                    .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background {
                        Capsule(style: .circular)
                            .stroke(lineWidth: 2)
                            .background(.white)
                    }
                    
                Rectangle()
                    .frame(height: 5)
                    .opacity(0)
            }
        }
    }
}

#Preview {
    HomeChartRefactored(.daily)
        .modelContainer(previewContainer)
}
