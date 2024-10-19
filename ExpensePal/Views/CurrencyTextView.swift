//
//  CurrencyTextView.swift
//  ExpensePal
//
//  Created by Gokul P on 18/10/24.
//

import Foundation
import SwiftUI

struct CurrencyTextView: View {

    var amountString: String
    @State var formattedText: String = "0.00"
    @State var locale: Locale

    init(amountString: String, locale: Locale) {
        self.amountString = amountString
        self.locale = locale
    }

    init(amountString: String) {
        self.amountString = amountString
        self.locale = Locale.current
    }

    var body: some View {
        Text(formattedText)
            .contentTransition(.numericText())
            .onChange(of: amountString) {
                formatString(amountString)
            }
            .onAppear {
                formatString(amountString)
            }
    }

    private func formatString(_ amountString: String) {
        let valueFormatted = format(string: amountString)
        if self.formattedText != valueFormatted {
            withAnimation {
                self.formattedText = valueFormatted
            }
        }
    }

    private func format(string: String) -> String {
        let digits = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
        let value = (Double(digits) ?? 0) / 100.0

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        currencyFormatter.currencySymbol = locale.currencySymbol
        
        let valueFormatted = currencyFormatter.string(from: NSNumber(value: value)) ?? ""
        return valueFormatted
    }
}

#Preview {
    CurrencyTextView(amountString: "123")
}
