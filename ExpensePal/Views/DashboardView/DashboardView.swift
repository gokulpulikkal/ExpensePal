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
    
//    @Query(filter: Expense.currentYearPredicate()) var expenseList: [Expense]
    @Query(Expense.firstTen()) var expenseList: [Expense]
    let dateObjectForFilter: Date = Date().firstDayOfYear() ?? Date()

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                FilterHeaderView()
                HomeChartComponent()
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
                Text("Total")
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

extension Date {
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
    func firstDayOfYear(using calendar: Calendar = .current) -> Date? {
        DateComponents(calendar: calendar, year: year(using: calendar)).date
    }
}


