//
//  AddExpenseViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 12/07/24.
//

import EmojiPicker
import Observation
import SwiftUI

extension AddExpenseView {
    @Observable
    class ViewModel {

        var expense: Expense

        init(expense: Expense? = nil) {
            if let expense {
                self.expense = expense
            } else {
                self.expense = Expense(emoji: "🛍️", title: "", cost: 0)
            }
        }

        func updateCost(input: String) {
            expense.cost = Double(input) ?? 0
        }

        func updateTitle(title: String) {
            expense.title = title
        }

        func updateEmoji(emoji: String?) {
            expense.emoji = emoji ?? "🛍️"
        }

        func updateSelectedDate(date: Date) {
            expense.date = date
        }
    }
}
