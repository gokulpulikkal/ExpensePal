//
//  DashboardView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct DashboardView: View {
    init() {
        print("Init DashboardView")
    }
    
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
                ForEach(1 ..< 10) { i in
                    ExpenseListCell()
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
                Text("today")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                Spacer()
                Text("-$308")
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
