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
    @State private var showingReceiptScanner = false

    @State var viewModel: ViewModel

    @State var keyPadInput: String
    @State var expenseTitle: String
    @State var selectedEmoji: Emoji?
    @State var displayEmojiPicker = false
    @State var selectedDate: Date

    init(viewModel: AddExpenseView.ViewModel) {
        self.viewModel = viewModel
        self.expenseTitle = viewModel.expense.title
        if floor(viewModel.expense.cost) == viewModel.expense.cost { // to make sure that the cost input behaves correct
            self.keyPadInput = String(Int(viewModel.expense.cost))
        } else {
            self.keyPadInput = String(viewModel.expense.cost)
        }
        self.selectedDate = viewModel.expense.date
    }

    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .frame(width: 31, height: 31)
                            .padding(.horizontal)
                            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                    })
                }
                Spacer()
                RoundedStrokeButton(
                    text: Text("vision capture"),
                    image: Image(systemName: "camera.viewfinder"),
                    action: {
                        showingReceiptScanner = true
                    }
                )
                VStack(spacing: 8) {
                    Text(viewModel.expense.cost, format: .currency(code: "USD"))
                        .bold()
                        .font(.largeTitle)
                }
                expenseInputView()
                    .padding(.bottom, 20)
                KeyPad(string: $keyPadInput)
                    .frame(width: 300, height: 350)
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
                Spacer()
            }
            .padding([.leading, .bottom, .trailing])
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(
                    selectedEmoji: $selectedEmoji,
                    selectedColor: .orange,
                    emojiProvider: LimitedEmojiProvider()
                )
                .navigationTitle("Emojis")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showingReceiptScanner) {
            ReceiptScanner()
        }
        .alert("Please add expense title", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: keyPadInput) {
            viewModel.updateCost(input: keyPadInput)
        }
        .onChange(of: expenseTitle) {
            viewModel.updateTitle(title: expenseTitle)
        }
        .onChange(of: selectedEmoji) {
            viewModel.updateEmoji(emoji: selectedEmoji?.value)
        }
        .onChange(of: selectedDate) {
            viewModel.updateSelectedDate(date: selectedDate)
        }
    }

    func expenseInputView() -> some View {
        HStack {
            Text(viewModel.expense.emoji)
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
            return viewModel.expense
        }
        return nil
    }
}

#Preview {
    AddExpenseView(viewModel: AddExpenseView.ViewModel())
}
