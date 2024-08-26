//
//  RegularHomeTabView.swift
//  ExpensePal
//
//  Created by Gokul P on 25/08/24.
//

import SwiftUI

struct RegularHomeTabView: View {
    @State private var selectedTab: iPadTabs? = .DashBoard

    var fillImage: String {
        (selectedTab?.rawValue ?? "") + ".fill"
    }

    var body: some View {
        NavigationSplitView {
            List {
                Section(content: {
                    ForEach(iPadTabs.allCases) { tab in
                        VStack {
                            HStack {
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
                            selectedTab = tab
                        }
                    }
                }, header: {
                    Text("Menu")
                })
            }
            .toolbar(.hidden, for: .navigationBar)
        } detail: {
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
    }
}

#Preview {
    RegularHomeTabView()
}
