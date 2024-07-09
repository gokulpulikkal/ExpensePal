//
//  ExpenseListCell.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct ExpenseListCell: View {
    var expense: Expense
    var body: some View {
        HStack {
            Text(expense.emoji)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(expense.title)
                    .bold()
                Text(expense.date, style: .date)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(expense.cost, format: .currency(code: "USD"))
                .bold()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ExpenseListCell(expense: Expense(
        emoji: "🐶",
        title: "Pet care",
        subTitle: "petco",
        cost: 179,
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    ))
}
