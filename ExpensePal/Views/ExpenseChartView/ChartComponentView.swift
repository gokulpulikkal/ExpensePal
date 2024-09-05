//
//  ChartComponentView.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import Charts
import SwiftUI
import ExpensePalModels

struct ChartComponentView: View {

    var filter: ExpenseChartMainFilter
    var data: [LinePlotEntry]

    // These are persistent ones
    @Binding var chartXSelection: String?
    @Binding var chartYSelection: Double?

    // these are non persistent
    @State var currentXSelection: String?
    @State var currentYSelection: Double?

    var body: some View {
        Chart {
            ForEach(data, id: \.id) { point in
                BarMark(
                    x: .value(point.xValueType, getExpenseChartDataPointsXValue(point.xValue)),
                    y: .value(point.yValueType, point.yValue)
                )
                .foregroundStyle(
                    chartXSelection == getExpenseChartDataPointsXValue(point.xValue)
                        ? Color(AppColors.primaryAccent.rawValue)
                        : .gray
                )
            }
        }
        .chartYAxis {
            AxisMarks(
                format: Decimal.FormatStyle.Currency(code: "USD")
            )
        }
        .chartXSelection(value: $currentXSelection)
        .chartYSelection(value: $currentYSelection)
//        .animation(.spring(duration: 1), value: data) //TODO: hiding for now.
        // animation is working but it is also affecting bar selection
        .onChange(of: currentXSelection) {
            if currentXSelection != nil {
                updateChartSelection(currentXSelection!)
            }
        }
        .onChange(of: chartXSelection) {
            updateInitialChartSelectionParams()
        }
        .onAppear(perform: {
            updateInitialChartSelectionParams()
        })
    }
    
    private func updateChartSelection(_ xLabel: String) {
        for item in data {
            if getExpenseChartDataPointsXValue(item.xValue) == xLabel {
                chartXSelection = xLabel
                chartYSelection = item.yValue
            }
        }
    }

    private func updateInitialChartSelectionParams() {
        if chartXSelection == nil, let point = data.last {
            chartXSelection = getExpenseChartDataPointsXValue(point.xValue)
            chartYSelection = point.yValue
        }
    }

    func getExpenseChartDataPointsXValue(_ date: Date) -> String {
        switch filter {
        case .Month:
            date.formatDateToMonth()
        case .Year:
            "\(date.year())"
        case .Week:
            date.formatDateToDayOfWeek()
        }
    }
}

#Preview {
    ChartComponentView(filter: .Month, data: [], chartXSelection: .constant(""), chartYSelection: .constant(0))
}
