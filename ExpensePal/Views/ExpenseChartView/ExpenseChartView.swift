//
//  ExpenseChartView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import Charts
import SwiftUI

struct ExpenseChartView: View {

    @AppStorage("chartFilterExpenseChart") var chartFilter: ExpenseChartMainFilter = .Month
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier
    
    @State var currentXSelection: String?
    @State var currentYSelection: Double?
    @State var averageYValue: Double = 0
    @State var isChartEmpty = false
    @State var animationCount = 0

    var body: some View {
        VStack {
            pageTitle
                .padding(.vertical)
            ScrollView {
                VStack {
                    mainFilterSelector
                        .padding(.vertical)
                    ZStack {
                        if !isChartEmpty {
                            chartContainer
                                .padding()
                                .background(
                                    Color(AppColors.primaryAccent.rawValue).opacity(0.08),
                                    in: RoundedRectangle(cornerRadius: 10)
                                )
                        } else {
                            noContentAnimationView
                        }
                    }
                }
                .padding(.horizontal, 3)
            }

            Spacer()
        }
        .padding(.horizontal)
        .onChange(of: chartFilter) {
            // TODO: refactor this update
            currentXSelection = nil
            currentYSelection = nil
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

    var chartContainer: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(currentXSelection ?? "") Summary")
                        .font(.title3)
                    Text(currentYSelection ?? 0, format: .currency(code: (Locales(localeIdentifier: localeIdentifier)?.currency ?? .USD).rawValue))
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
                $averageYValue,
                $isChartEmpty
            )
            .padding(.bottom)
            HStack {
                Text("\(chartFilter.description)ly average spending")
                    .font(.title3)
                Spacer()
                Text(averageYValue, format: .currency(code: (Locales(localeIdentifier: localeIdentifier)?.currency ?? .USD).rawValue))
                    .font(.title3)
            }
        }
    }

    var noContentAnimationView: some View {
        VStack {
            Image(systemName: "chart.bar.xaxis.ascending")
                .resizable()
                .frame(width: 80, height: 80)
                .symbolEffect(.bounce, value: animationCount)
                .padding(.bottom)
            Group {
                Text("Nothing to show here")
                Text("Let's first add some Expenses!!")
            }
            .bold()
        }
        .frame(width: 300, height: 300)
        .padding()
        .background(
            Color(AppColors.primaryAccent.rawValue).opacity(0.08),
            in: RoundedRectangle(cornerRadius: 10)
        )
        .onTapGesture {
            animationCount += 1
        }
    }
}

#if DEBUG
#Preview {
    ExpenseChartView()
        .modelContainer(previewContainer)
}
#endif
