//
//  AddExpenseView.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import EmojiPicker
import SwiftData
import SwiftUI

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false

    @State var keyPadInput: String = "0"
    @State var expenseTitle: String = ""
    @State var selectedEmoji: Emoji?
    @State var displayEmojiPicker: Bool = false
    @State var selectedDate = Date.now

    var body: some View {
        VStack(spacing: 20) {
            RoundedStrokeButton(text: Text("vision capture"),
                                image: Image(systemName: "camera.viewfinder"), action: {
                                }
            )
            .padding(.bottom)
            VStack(spacing: 8) {
                Text(Double(keyPadInput) ?? 0, format: .currency(code: "USD"))
                    .bold()
                    .font(.largeTitle)
            }
            expenseInputView()
            KeyPad(string: $keyPadInput)
                .padding(.vertical)

            Button("Done") {
                if let expense = getInputExpense() {
                    modelContext.insert(expense)
                    dismiss()
                } else {
                    showingAlert = true
                }
            }
            .bold()
            .padding(14)
            .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
            .background(Color(AppColors.primaryAccent.rawValue))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange, emojiProvider: LimitedEmojiProvider())
                    .navigationTitle("Emojis")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Please add expense title", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    func expenseInputView() -> some View {
        HStack {
            Text(selectedEmoji?.value ?? "🛍️")
                .padding(12)
                .background(Color(AppColors.primaryAccent.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    displayEmojiPicker = true
                }

            TextField("", text: $expenseTitle, prompt: Text("Expense Title").foregroundColor(.gray))
                .frame(maxWidth: 100)
                .font(.system(size: 15))
                .bold()
                .padding(12)
                .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
                .background(Color(AppColors.primaryAccent.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Image(systemName: "calendar.circle")
                .resizable()
                .frame(width: 35, height: 35)
                .overlay {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .blendMode(.destinationOver) // making it clickable
                }
        }
    }

    func getInputExpense() -> Expense? {
        if expenseTitle != "" {
            let expenseCost = keyPadInput
            let emoji = selectedEmoji?.value ?? "🛍️"
            return Expense(emoji: emoji, title: expenseTitle, cost: Double(expenseCost) ?? 0, date: selectedDate)
        }
        return nil
    }
}

#Preview {
    AddExpenseView()
}
