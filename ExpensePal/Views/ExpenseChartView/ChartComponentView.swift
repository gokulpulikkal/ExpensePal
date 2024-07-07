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

    var body: some View {
        Chart {
            ForEach(data, id: \.id) { point in
                BarMark(
                    x: .value(point.xValueType, getExpenseChartDataPointsXValue(point.xValue)),
                    y: .value(point.yValueType, point.yValue)
                )
                .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
            }
        }
    }
    
    func getExpenseChartDataPointsXValue(_ date: Date) -> String {
        switch filter {
        case .Month:
            date.formatDateToMonth()
        case .Year:
            date.formatDateToWeekOfMonth()
        case .Week:
            date.formatDateToDayOfWeek()
        }
    }
}

#Preview {
    ChartComponentView(filter: .Month, data: [])
}
