//
//  TestView.swift
//  ExpensePal
//
//  Created by Gokul P on 11/06/24.
//

import SwiftUI

struct TestView: View {
    
    @State private var selectedTab: Tab = .DashBoard
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Rectangle()
                    .frame(width: .infinity, height: 300)
                recentExpenseList()
            }
        }
    }
    
    func recentExpenseList() -> some View {
        LazyVStack(spacing: 30) {
            Section {
              // Here goes the items
//                ForEach(1 ..< 6) { i in
//                    ExpenseListCell(expense: <#Expense#>)
//                }
            } header: {
                RecentExpenseListHeader()
            }
        }
        .padding()
    }
    
    func RecentExpenseListHeader() -> some View {
        VStack {
            HStack {
                Text("today")
                Spacer()
                Text("-$308")
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}

#Preview {
    TestView()
}
