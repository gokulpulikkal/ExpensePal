//
//  NavigationModel.swift
//  ExpensePal
//
//  Created by Gokul P on 30/10/24.
//

import Foundation
import Observation
import SwiftUI

/// An observable object that manages the selection events for `NavigationSplitView`.
@MainActor
@Observable
class NavigationModel {

    /// The selected item in `SidebarColumn`.
    var selectedTab: Tab

    var selectedPopoverTab: Tab?

    init(selectedTab: Tab?) {
        if let selectedTab {
            self.selectedTab = selectedTab
        } else {
            self.selectedTab = .DashBoard
        }
    }

    func setSelectedTab(tab: Tab) {
        switch tab {
        case .DashBoard,
             .ExpenseList,
             .ExpenseChart,
             .Settings:
            selectedTab = tab
        case .AddExpense:
            selectedPopoverTab = tab
        }
    }
}
