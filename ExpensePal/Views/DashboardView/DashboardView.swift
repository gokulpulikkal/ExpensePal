//
//  DashboardView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
    var viewModel = DashboardViewModel()
    @Environment(\.modelContext) var modelContext

    @Query(Expense.firstTen()) var expenseList: [Expense]
    @State var chartFilter: ExpenseChartFilter = .daily
    @State var presentingSearchView = false

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
        })
        .sheet(isPresented: $presentingSearchView) {
            ExpenseSearchView()
        }
    }

    func recentExpenseList() -> some View {
        LazyVStack(spacing: 18) {
            Section {
                if !expenseList.isEmpty {
                    ForEach(expenseList, id: \.id) { expense in
                        ExpenseListCell(expense: expense)
                            .padding(.vertical, 5)
                    }
                } else {
                    VStack {
                        Text("All your recent Expenses will come here")
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                    .frame(width: 250, height: 300)
                }
            } header: {
                RecentExpenseListHeader()
            }
        }
        .padding(.horizontal, 20)
    }

    func RecentExpenseListHeader() -> some View {
        VStack {
            HStack {
                Text("Recent Expenses")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                Spacer()
                Text(expenseList.reduce(0) { $0 + $1.cost }, format: .currency(code: "USD"))
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(previewContainer)
}
