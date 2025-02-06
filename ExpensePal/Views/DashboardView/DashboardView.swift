//
//  DashboardView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import ExpensePalModels
import SwiftData
import SwiftUI
import SwipeActions

struct DashboardView: View {
    @State var viewModel = DashboardViewModel()

    @Query(Expense.firstTen()) var expenseList: [Expense]
    @AppStorage("chartFilterDashBoard") var chartFilter: ExpenseChartFilter = .daily
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier
    @State var presentingSearchView = false
    private var columns = [
        GridItem(.adaptive(minimum: 350, maximum: 350), spacing: 50)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FilterHeaderView(chartFilter: $chartFilter, didTapSearchIcon: $presentingSearchView)
                HomeChartRefactored(chartFilter)
                    .frame(height: 300)
                    .padding(.vertical)
                recentExpenseList()
            }
        }
        .onAppear(perform: {
            viewModel.expenseList = expenseList
            viewModel.getRecentExpenses()
        })
        .sheet(isPresented: $presentingSearchView) {
            ExpenseSearchView()
        }
        .onChange(of: localeIdentifier) {
            viewModel.localeIdentifier = localeIdentifier
        }
        .onChange(of: expenseList) {
            viewModel.expenseList = expenseList
            viewModel.getRecentExpenses()
        }
    }

    func recentExpenseList() -> some View {
        Group {
            LazyVGrid(columns: columns, spacing: 18) {
                Section {
                    if !expenseList.isEmpty {
                        ForEach(expenseList, id: \.id) { expense in
                            ExpenseListCell(expense: expense)
                                .padding(.vertical, 5)
                        }
                    }
                } header: {
                    RecentExpenseListHeader()
                        .padding(.horizontal, 20)
                }
            }
            .animation(.bouncy, value: expenseList)
            if expenseList.isEmpty {
                VStack {
                    Text("All your recent Expenses will come here")
                        .multilineTextAlignment(.center)
                        .bold()
                }
                .frame(width: 250, height: 300)
            }
        }
    }

    func RecentExpenseListHeader() -> some View {
        VStack {
            HStack {
                let totalRecentExpenses = expenseList.reduce(0) {
                    let convertedVal = CurrencyConverter.shared.convert(
                        $1.cost,
                        valueCurrency: (Locales(rawValue: $1.locale)?.currency ?? .USD),
                        outputCurrency: Locales(localeIdentifier: localeIdentifier)?.currency ?? .USD
                    ) ?? 0
                    return $0 + convertedVal
                } // Only first ten are gonna show in this list. So it is okay to do this
                Text("Recent Expenses")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                Spacer()
                Text(
                    totalRecentExpenses,
                    format: .currency(code: (Locales(localeIdentifier: localeIdentifier)?.currency ?? .USD).rawValue)
                )
                .foregroundStyle(.gray)
                .font(.subheadline)
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}

#if DEBUG
#Preview {
    DashboardView()
        .modelContainer(previewContainer)
}
#endif
