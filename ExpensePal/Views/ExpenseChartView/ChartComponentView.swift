//
//  ChartComponentView.swift
//  ExpensePal
//
//  Created by Gokul P on 06/07/24.
//

import Charts
import SwiftUI

struct ChartComponentView: View {

    var filter: ExpenseChartMainFilter
    var data: [LinePlot]

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
        .chartXSelection(value: $currentXSelection)
        .chartYSelection(value: $currentYSelection)
        .onChange(of: currentXSelection) {
            if currentXSelection != nil {
                chartXSelection = currentXSelection!
            }
        }
        .onChange(of: currentYSelection) {
            if currentYSelection != nil {
                chartYSelection = currentYSelection!
            }
        }
        .onChange(of: chartXSelection, {
            if chartXSelection == nil, let point = data.last {
                chartXSelection = getExpenseChartDataPointsXValue(point.xValue)
                chartYSelection = point.yValue
            }
        })
        .onAppear(perform: {
            if chartXSelection == nil, let point = data.last {
                chartXSelection = getExpenseChartDataPointsXValue(point.xValue)
                chartYSelection = point.yValue
            }
        })
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
