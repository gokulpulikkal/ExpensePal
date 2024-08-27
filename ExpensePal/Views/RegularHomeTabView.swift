//
//  RegularHomeTabView.swift
//  ExpensePal
//
//  Created by Gokul P on 25/08/24.
//

import SwiftUI

struct RegularHomeTabView: View {

    @Environment(\.openWindow) private var openWindow
    @State var shouldShowAddExpenseView = false
    @State private var selectedTab: iPadTabs? = .DashBoard

    var fillImage: String {
        (selectedTab?.rawValue ?? "") + ".fill"
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
        .fullScreenCover(isPresented: $shouldShowAddExpenseView) {
            AddExpenseView(viewModel: AddExpenseView.ViewModel())
        }
    }

    @ViewBuilder
    var detailsViewContainer: some View {
        if let selectedTab {
            switch selectedTab {
            case .DashBoard:
                DashboardView()
            case .ExpenseList:
                ExpenseListView()
            case .ExpenseChart:
                ExpenseChartView()
            case .Settings:
                SettingsView()
            }
        }
    }

    var menuList: some View {
        List {
            ForEach(iPadTabs.allCases) { tab in
                VStack {
                    HStack(spacing: 20) {
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1)

                        Text(tab.title)
                            .font(.title2)
                            .bold(selectedTab == tab)
                    }
                    .padding(.bottom)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.top)
        }
        .listRowSpacing(ProcessInfo.processInfo.isiOSAppOnMac ? 20: 0)
        
    }

    var addExpenseButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if ProcessInfo.processInfo.isiOSAppOnMac {
                        openWindow(id: "addExpenseView")
                    } else {
                        shouldShowAddExpenseView = true
                    }
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

#Preview {
    RegularHomeTabView()
        .modelContainer(previewContainer)
}
