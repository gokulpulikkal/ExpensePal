//
//  DashboardView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
    var viewModel: DashboardViewModel = DashboardViewModel()
    @Environment(\.modelContext) var modelContext
    
    @Query(Expense.firstTen()) var expenseList: [Expense]
    @State var chartFilter: ExpenseChartFilter = .monthly

    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                Spacer()
                FilterHeaderView(chartFilter: $chartFilter)
                HomeChartComponent(chartFilter)
                    .frame(height: 370)
                recentExpenseList()
            }
        }
        .onAppear(perform: {
            viewModel.expenseList = self.expenseList
        })
    }

    func recentExpenseList() -> some View {
        LazyVStack(spacing: 18) {
            Section {
                // Here goes the items
                ForEach(expenseList, id: \.id) { expense in
                    ExpenseListCell(expense: expense)
                }
            } header: {
                RecentExpenseListHeader()
            }
        }
        .padding()
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


