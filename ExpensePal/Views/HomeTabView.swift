//
//  HomeTabView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct HomeTabView: View {
    @State var shouldShowAddExpenseView = false

    @Environment(NavigationModel.self) private var navigationModel

    var body: some View {
        VStack {
            mainView
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: navigationModel.selectedTab)
            Spacer()
            CustomTabBar()
                .frame(height: 35)
        }
        .onChange(of: navigationModel.selectedPopoverTab) {
            if navigationModel.selectedPopoverTab == .AddExpense {
                shouldShowAddExpenseView = true
            }
        }
        .fullScreenCover(isPresented: $shouldShowAddExpenseView) {
            switch navigationModel.selectedPopoverTab {
            default:
                AddExpenseView(viewModel: AddExpenseView.ViewModel())
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    var mainView: some View {
        ZStack {
            switch navigationModel.selectedTab {
            case .DashBoard:
                DashboardView()
            case .ExpenseList:
                ExpenseListView()
            case .ExpenseChart:
                ExpenseChartView()
            case .AddExpense:
                DashboardView()
            case .Settings:
                SettingsView()
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
