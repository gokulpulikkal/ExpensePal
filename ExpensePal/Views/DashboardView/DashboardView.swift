//
//  DashboardView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct DashboardView: View {
    var viewModel: DashboardViewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                FilterHeaderView()
                HomeChartComponent()
                    .frame(width: .infinity, height: 370)
                recentExpenseList()
            }
        }
    }
    
    func recentExpenseList() -> some View {
        LazyVStack(spacing: 18) {
            Section {
              // Here goes the items
                ForEach(viewModel.expenseList, id: \.id) { expense in
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
                Text(viewModel.totalRecentExpenses, format: .currency(code: "USD"))
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
}
