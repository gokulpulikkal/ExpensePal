//
//  ExpenseChartView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import Charts
import SwiftUI

struct ExpenseChartView: View {
    @State var chartFilter: ExpenseChartMainFilter = .Month
    var body: some View {
        VStack {
            pageTitle
            mainFilterSelector
                .padding(.horizontal)
            BarChartPresenter(chartFilter)

            Spacer()
        }
    }

    var pageTitle: some View {
        HStack {
            Text("Report")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
        .padding()
    }

    var mainFilterSelector: some View {
        HStack {
            Menu {
                ForEach(ExpenseChartMainFilter.allCases) { filter in

                    Button(filter.description) {
                        chartFilter = filter
                    }
                    .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                    .padding(.vertical)
                }
            } label: {
                RoundedStrokeButton(
                    text: Text(chartFilter.description),
                    image: Image(systemName: "chevron.down"),
                    action: {}
                )
            }
            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
            Spacer()
        }
    }
}

#Preview {
    ExpenseChartView()
        .modelContainer(previewContainer)
}
