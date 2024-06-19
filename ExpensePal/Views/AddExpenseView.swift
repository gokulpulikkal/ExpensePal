//
//  AddExpenseView.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI
import SwiftData
import EmojiPicker

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var keyPadInput: String = "0"
    @State var expenseTitle: String = ""
    @State var selectedEmoji: Emoji?
    @State var displayEmojiPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedStrokeButton(text: Text("vision capture"),
                                image: Image(systemName: "camera.viewfinder")
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
            
            Button("Add Expense") {
                let expense = Expense(emoji: selectedEmoji?.value ?? "🛍️", title: expenseTitle, cost: Double(keyPadInput) ?? 0)
                modelContext.insert(expense)
                dismiss()
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
        }
    }
}

#Preview {
    AddExpenseView()
}
