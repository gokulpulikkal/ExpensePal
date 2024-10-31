//
//  CustomTabBar.swift
//  ExpensePal
//
//  Created by Gokul P on 15/06/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case DashBoard = "house.circle"
    case ExpenseList = "list.bullet.circle"
    case AddExpense = "plus.circle"
    case ExpenseChart = "chart.pie"
    case Settings = "gearshape"
}

struct CustomTabBar: View {
    @Environment(NavigationModel.self) private var navigationModel

    var fillImage: String {
        navigationModel.selectedTab.rawValue + ".fill"
    }

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                Image(systemName: navigationModel.selectedTab == tab ? fillImage : tab.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .scaleEffect(navigationModel.selectedTab == tab ? 1.25 : 1)
                    .onTapGesture {
                        navigationModel.setSelectedTab(tab: tab)
                    }
                Spacer()
            }
        }
        .frame(height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    CustomTabBar()
}
