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
    @State var shouldShowAddExpenseView = false

    var body: some View {
        VStack {
            getMainView(currentTab)
                .animation(.easeInOut(duration: 0.2), value: currentTab)
            Spacer()
            CustomTabBar(selectedTab: $selectedTab, selectedPopOverTab: $shouldShowAddExpenseView)
                .frame(height: 35)
        }
        .onChange(of: selectedTab) {
            currentTab = selectedTab
        }
        .fullScreenCover(isPresented: $shouldShowAddExpenseView) {
            AddExpenseView(viewModel: AddExpenseView.ViewModel())
        }
        .ignoresSafeArea(.keyboard)
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
                AddExpenseView(viewModel: AddExpenseView.ViewModel())
            case .Settings:
                SettingsView()
                    .transition(.opacity)
            }
        }
    }
}
#if DEBUG
#Preview {
    HomeTabView()
        .modelContainer(previewContainer)
}
#endif
