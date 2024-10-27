//
//  HomeChartRefactored.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import Charts
import SwiftData
import SwiftUI
import ExpensePalModels

struct HomeChartRefactored: View {
    @Query var expenseList: [Expense]
    var viewModel = ViewModel()
    var filter: ExpenseChartFilter
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier

    @State var selectedDateStringInChart: String?
    @State var persistentSelectedDateString: String?
    @State var animationCount = 0

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
            if isChartIsEmpty() {
                noContentAnimationView
            } else {
                Text(
                    viewModel.getTotalExpenseForPlot(viewModel.getExpenseChartDataPoints(filter, expenseList)),
                    format: .currency(code:( Locales(localeIdentifier: localeIdentifier)?.currency ?? .USD).rawValue)
                )
                .bold()
                .font(.largeTitle)
                chartView()
            }
        }
        .onChange(of: selectedDateStringInChart) {
            if selectedDateStringInChart != nil {
                persistentSelectedDateString = selectedDateStringInChart
            }
        }
        .onChange(of: filter) {
            persistentSelectedDateString = nil
        }
        .onChange(of: localeIdentifier) {
            viewModel.localeIdentifier = localeIdentifier
        }
    }

    private func isChartIsEmpty() -> Bool {
        expenseList.isEmpty
    }

    var noContentAnimationView: some View {
        VStack {
            Image(systemName: "chart.bar.xaxis.ascending")
                .resizable()
                .frame(width: 80, height: 80)
                .symbolEffect(.bounce, value: animationCount)
                .padding(.bottom)
            Group {
                Text("Nothing to show here for \(filter.description.lowercased())")
            }
            .bold()
        }
        .frame(width: 300, height: 300)
        .padding()
        .onTapGesture {
            animationCount += 1
        }
    }

    private func chartView() -> some View {
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
                if selectedDateStringInChart == viewModel.getExpenseChartDataPointsXValue(filter, data.xValue) {
                    chartPointInfoView(for: data)
                }
            }
        }
        .chartYScale(range: .plotDimension(startPadding: 10, endPadding: 10))
        .chartXScale(range: .plotDimension(startPadding: 10, endPadding: 10))
        .chartYAxis(.hidden)
        .chartXSelection(value: $selectedDateStringInChart)
        .chartYScale(domain: [viewModel.minYRange - 20, viewModel.maxYRange + 10])
        .aspectRatio(1.5, contentMode: .fit)
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .animation(Animation.easeInOut(duration: 0.1), value: filter)
    }

    private func chartSymbol(for xValue: Date) -> some View {
        VStack {
            if viewModel
                .getExpenseChartDataPointsXValue(filter, xValue) == persistentSelectedDateString ||
                (persistentSelectedDateString == nil && viewModel.getExpenseChartDataPointsXValue(
                    filter,
                    xValue
                ) == viewModel.lastDataPointDateString)
            {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 17)
                    .background(Color(AppColors.primaryBackground.rawValue))
                    .clipShape(Circle())
            }
        }
    }

    private func chartPointInfoView(for point: LinePlotEntry) -> some ChartContent {
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
                            .background(Color(AppColors.primaryBackground.rawValue))
                    }
                    .clipShape(
                        Capsule(style: .circular)
                    )

                Rectangle()
                    .frame(height: 5)
                    .opacity(0)
            }
        }
    }
}

#if DEBUG
#Preview {
    HomeChartRefactored(.monthly)
        .modelContainer(previewContainer)
}
#endif
