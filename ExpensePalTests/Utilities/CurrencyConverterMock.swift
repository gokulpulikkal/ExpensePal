//
//  CurrencyConverterMock.swift
//  ExpensePalTests
//
//  Created by Gokul P on 12/25/24.
//

import Foundation
@testable import ExpensePal

struct CurrencyConverterMock: CurrencyConverterProtocol {
    public func updateExchangeRates() async {}

    public func convert(_ value: Double, valueCurrency: Currency, outputCurrency: Currency) -> Double? {
        value
    }

    public func convertAndFormat(
        _ value: Double,
        valueCurrency: Currency,
        outputCurrency: Currency,
        numberStyle: NumberFormatter.Style,
        decimalPlaces: Int
    ) -> String? {
        format(value, numberStyle: numberStyle, decimalPlaces: decimalPlaces)
    }

    public func format(_ value: Double, numberStyle: NumberFormatter.Style, decimalPlaces: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: NSNumber(value: value))
    }
}
