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
    
    @Binding var selectedTab: Tab
    
    var fillImage: String {
        return selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                Image(systemName: selectedTab == tab ? fillImage: tab.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .scaleEffect(selectedTab == tab ? 1.25: 1)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            selectedTab = tab
                        }
                    }
                Spacer()
            }
        }
        .frame(height: 50)
//        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.DashBoard))
}
