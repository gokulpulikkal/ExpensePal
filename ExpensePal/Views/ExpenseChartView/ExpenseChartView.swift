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
    @State var currentXSelection: String?
    @State var currentYSelection: Double?
    @State var averageYValue: Double = 0

    var body: some View {
        VStack {
            pageTitle
            mainFilterSelector
                .padding(.bottom)
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(currentXSelection ?? "") Summary")
                            .font(.title3)
                        Text(currentYSelection ?? 0, format: .currency(code: "USD"))
                            .font(.title3)
                        Text("Spent so far")
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                BarChartPresenter(
                    chartFilter,
                    $currentXSelection,
                    $currentYSelection,
                    $averageYValue
                )
                .padding(.bottom)
                HStack {
                    Text("Average spending")
                        .font(.title3)
                    Spacer()
                    Text(averageYValue, format: .currency(code: "USD"))
                        .font(.title3)
                }
            }
            .padding()
            .background(Color(AppColors.primaryAccent.rawValue).opacity(0.08), in: RoundedRectangle(cornerRadius: 10))

            Spacer()
        }
        .padding(.horizontal)
        .onChange(of: chartFilter, {
            // TODO: refactor this update 
            currentXSelection = nil
            currentYSelection = nil
        })
    }

    var pageTitle: some View {
        HStack {
            Text("Report")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
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
