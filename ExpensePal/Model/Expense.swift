//
//  Expense.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Foundation

struct Expense {
    var id = UUID()
    var emoji: String
    var title: String
    var subTitle:String
    var cost: Double
    var date: Date
}
