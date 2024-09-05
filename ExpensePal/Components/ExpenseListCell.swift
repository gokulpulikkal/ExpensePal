//
//  ExpenseListCell.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI
import SwipeActions
import ExpensePalModels

struct ExpenseListCell: View {
    
    @Environment(\.modelContext) var modelContext
    @State var presentingEditExpenseView = false
    
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
        .addSwipeAction(edge: .trailing) {
            HStack {
                Button {
                    presentingEditExpenseView = true
                } label: {
                    Image(systemName: "pencil")
                        .tint(.primaryBGColour)
                }
                .frame(width: 60, height: 50, alignment: .center)
                .background(Color(AppColors.primaryAccent.rawValue), in: RoundedRectangle(cornerRadius: 10))
                
                Button {
                    modelContext.delete(expense)
                } label: {
                    Image(systemName: "trash")
                        .tint(.primaryBGColour)
                }
                .frame(width: 60, height: 50, alignment: .center)
                .background(Color(AppColors.primaryAccent.rawValue), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(width: 360)
        .clipped()
        .fullScreenCover(isPresented: $presentingEditExpenseView, content: {
            AddExpenseView(viewModel: AddExpenseView.ViewModel(expense: expense))
        })
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
