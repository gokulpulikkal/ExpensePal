//
//  ExpensePalWidgetsEntryView.swift
//  ExpensePalWidgetsExtension
//
//  Created by Gokul P on 1/1/25.
//

import ExpensePalModels
import SwiftData
import SwiftUI
import WidgetKit

struct ExpensePalWidgetsEntryView: View {
    @Query var expenseList: [Expense]
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier

    var body: some View {
        VStack {
            Text("Total Expense")
                .bold()
            Text(
                expenseList.reduce(0) { $0 + $1.cost },
                format: .currency(code: Currency.USD.rawValue)
            )
        }
    }
}
