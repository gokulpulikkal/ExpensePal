//
//  HomeTabView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct HomeTabView: View {
    @State var selectedTab: Tab = .DashBoard
    @State var currentTab: Tab = .DashBoard
    @State private var shouldShowAddExpenseView: Bool = false
    
    var body: some View {
        VStack {
            getMainView(currentTab)
                .animation(.easeInOut(duration: 0.3), value: currentTab)
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
                .frame(height: 20)
        }.onChange(of: selectedTab, {
            if selectedTab != .AddExpense {
                currentTab = selectedTab
            } else {
                shouldShowAddExpenseView = true
                selectedTab = currentTab
            }
        })
        .popover(isPresented: $shouldShowAddExpenseView) {
            AddExpenseView()
                .presentationCompactAdaptation(.sheet)
        }
    }

    private func getMainView(_ selectedTab: Tab) -> some View {
        ZStack {
            switch selectedTab {
            case .DashBoard:
                DashboardView()
                    .transition(.opacity)
            case .ExpenseList:
                ExpenseListView()
                    .transition(.opacity)
            case .ExpenseChart:
                ExpenseChartView()
                    .transition(.opacity)
            case .AddExpense:
                ExpenseListView()
                    .transition(.opacity)
            case .Settings:
                SettingsView()
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    HomeTabView()
}
