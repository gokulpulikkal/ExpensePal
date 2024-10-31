//
//  RegularHomeTabView.swift
//  ExpensePal
//
//  Created by Gokul P on 25/08/24.
//

import SwiftUI

struct RegularHomeTabView: View {

    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.openWindow) private var openWindow
    @State var shouldShowAddExpenseView = false

    let tabs: [Tab] = [.DashBoard, .ExpenseList, .ExpenseChart, .Settings]

    var fillImage: String {
        (navigationModel.selectedTab.rawValue) + ".fill"
    }

    var body: some View {
        NavigationSplitView {
            menuList
        } detail: {
            ZStack {
                detailsViewContainer
                addExpenseButtonView
            }
        }
        .tint(Color(AppColors.primaryAccent.rawValue))
        .onChange(of: navigationModel.selectedPopoverTab) {
            if navigationModel.selectedPopoverTab == .AddExpense {
                if ProcessInfo.processInfo.isiOSAppOnMac {
                    openWindow(id: "addExpenseView")
                } else {
                    shouldShowAddExpenseView = true
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowAddExpenseView) {
            AddExpenseView(viewModel: AddExpenseView.ViewModel())
        }
    }

    @ViewBuilder
    var detailsViewContainer: some View {
        switch navigationModel.selectedTab {
        case .DashBoard:
            DashboardView()
        case .ExpenseList:
            ExpenseListView()
        case .ExpenseChart:
            ExpenseChartView()
        case .Settings:
            SettingsView()
        default:
            DashboardView()
        }
    }

    var menuList: some View {
        List {
            ForEach(tabs, id: \.self) { tab in
                VStack {
                    HStack(spacing: 20) {
                        Image(systemName: navigationModel.selectedTab == tab ? fillImage : tab.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .scaleEffect(navigationModel.selectedTab == tab ? 1.25 : 1)

                        Text(tab.title)
                            .font(.title2)
                            .bold(navigationModel.selectedTab == tab)
                    }
                    .padding(.bottom)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        navigationModel.setSelectedTab(tab)
                    }
                }
            }
            .padding(.top)
        }
        .listRowSpacing(ProcessInfo.processInfo.isiOSAppOnMac ? 20 : 0)
    }

    var addExpenseButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    navigationModel.setSelectedTab(.AddExpense)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                })
                .tint(.primary)
            }
        }
        .padding(50)
    }
}

#if DEBUG
#Preview {
    RegularHomeTabView()
        .modelContainer(previewContainer)
}
#endif
