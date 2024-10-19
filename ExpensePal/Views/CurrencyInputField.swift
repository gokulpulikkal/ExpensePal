//
//  CurrencyTextView.swift
//  ExpensePal
//
//  Created by Gokul P on 18/10/24.
//

import Foundation
import SwiftUI

struct CurrencyTextView: View {

    @Binding var amountString: String
    @State var locale: Locale

    init(amountString: Binding<String>, locale: Locale) {
        _amountString = amountString
        self.locale = locale
    }

    init(amountString: Binding<String>) {
        _amountString = amountString
        self.locale = Locale.current
    }

    var body: some View {
        Text(amountString)
            .onChange(of: amountString) {
                formatString(amountString)
            }
            .onAppear {
                formatString(amountString)
            }
    }

    private func formatString(_ amountString: String) {
        let valueFormatted = format(string: amountString)
        if self.amountString != valueFormatted {
            self.amountString = valueFormatted
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
    CurrencyTextView(amountString: .constant("123"))
}
