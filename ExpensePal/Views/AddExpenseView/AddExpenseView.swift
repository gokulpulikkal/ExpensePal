//
//  AddExpenseView.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import AVFoundation
import ExpensePalModels
import SwiftData
import SwiftUI
import WidgetKit

struct AddExpenseView: View {
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("localeIdentifier") var localeIdentifier: String = Locales.USA.localeIdentifier
    @FocusState var isTitleTextFieldFocused: Bool

    @State private var showingAlert = false
    @State private var showingReceiptScanner = false

    @State var viewModel: ViewModel

    @State var keyPadInput: String
    @State var expenseTitle: String
    @State var selectedEmojiString = ""
    @State var displayEmojiPicker = false
    @State var selectedDate: Date
    @State private var scannedImage: UIImage? = nil
    @State private var showActivityIndicator = false

    init(viewModel: AddExpenseView.ViewModel) {
        self.viewModel = viewModel
        self.expenseTitle = viewModel.expense.title
        self.keyPadInput = String(format: "%.2f", viewModel.expense.cost)
        self.selectedDate = viewModel.expense.date
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            closeView()
                        }, label: {
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(.horizontal)
                                .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                                .opacity(ProcessInfo.processInfo.isiOSAppOnMac ? 0 : 1)
                        })
                    }
                    Spacer()
                    if !ProcessInfo.processInfo.isiOSAppOnMac {
                        RoundedStrokeButton(
                            text: Text("vision capture"),
                            image: Image(systemName: "camera.viewfinder"),
                            action: {
                                Task {
                                    await setUpCaptureSession()
                                }
                            }
                        )
                    }
                    VStack(spacing: 8) {
                        CurrencyTextView(amountString: keyPadInput, locale: Locale(identifier: localeIdentifier))
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
                            closeView()
                            WidgetCenter.shared.reloadAllTimelines()
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
                if showActivityIndicator {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(AppColors.primaryAccent.rawValue)))
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .sheet(isPresented: $showingReceiptScanner) {
            VNDocumentViewControllerRepresentable(scanResult: $scannedImage)
        }
        .alert("Please add expense title", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: showingReceiptScanner) {
            if showActivityIndicator, scannedImage == nil {
                showActivityIndicator = false
            } else {
                showActivityIndicator = true
            }
        }
        .onChange(of: keyPadInput) {
            viewModel.updateCost(input: keyPadInput, locale: Locale(identifier: localeIdentifier))
            isTitleTextFieldFocused = false
        }
        .onChange(of: expenseTitle) {
            viewModel.updateTitle(title: expenseTitle)
        }
        .onChange(of: selectedEmojiString) {
            viewModel.updateEmoji(emoji: selectedEmojiString)
        }
        .onChange(of: selectedDate) {
            viewModel.updateSelectedDate(date: selectedDate)
        }
        .onChange(of: scannedImage) {
            if let scannedImage {
                viewModel.recognizeText(scannedImage: scannedImage)
            }
        }
        .onChange(of: viewModel.expense) {
            showActivityIndicator = false
            expenseTitle = viewModel.expense.title
            selectedDate = viewModel.expense.date
        }
        .onAppear {
            navigationModel.selectedPopoverTab = nil // setting it to the default
        }
    }

    func closeView() {
        navigationModel.selectedPopoverTab = nil
        dismiss()
    }

    func expenseInputView() -> some View {
        HStack {
            Button(viewModel.expense.emoji) {
                displayEmojiPicker.toggle()
            }.emojiPicker(
                isPresented: $displayEmojiPicker,
                selectedEmoji: $selectedEmojiString
            )
            .padding(12)
            .background(Color(AppColors.primaryAccent.rawValue))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            TextField("", text: $expenseTitle, prompt: Text("Expense Title").foregroundColor(.gray))
                .focused($isTitleTextFieldFocused)
                .frame(maxWidth: 100)
                .font(.system(size: 15))
                .bold()
                .padding(12)
                .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
                .background(Color(AppColors.primaryAccent.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text("\(selectedDate.formatted(.dateTime.month(.abbreviated).day(.defaultDigits)))")
                .bold()
                .padding(11)
                .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
                .background(Color(AppColors.primaryAccent.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
            if let locale = Locales(localeIdentifier: localeIdentifier) {
                viewModel.expense.locale = locale.rawValue
            }

            return viewModel.expense
        }
        return nil
    }

    private func setUpCaptureSession() async {
        guard await isAuthorized else {
            return
        }
        showingReceiptScanner = true
    }

    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)

            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized

            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }

            return isAuthorized
        }
    }

}

#Preview {
    AddExpenseView(viewModel: AddExpenseView.ViewModel())
}
