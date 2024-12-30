//
//  CurrencyConverterProtocol.swift
//  ExpensePal
//
//  Created by Gokul P on 12/25/24.
//

import Foundation

protocol CurrencyConverterProtocol {

    /// Updates the exchange rate asynchronously
    func updateExchangeRates() async

    /// Converts a value from one currency to another
    /// - Parameters:
    ///   - value: The amount to convert
    ///   - valueCurrency: The currency of the input amount
    ///   - outputCurrency: The desired output currency
    /// - Returns: The converted amount or nil if conversion fails
    func convert(_ value: Double, valueCurrency: Currency, outputCurrency: Currency) -> Double?

    /// Converts and formats a value from one currency to another
    /// - Parameters:
    ///   - value: The amount to convert
    ///   - valueCurrency: The currency of the input amount
    ///   - outputCurrency: The desired output currency
    ///   - numberStyle: The number formatting style to apply
    ///   - decimalPlaces: The number of decimal places in the formatted output
    /// - Returns: A formatted string representing the converted amount
    func convertAndFormat(
        _ value: Double,
        valueCurrency: Currency,
        outputCurrency: Currency,
        numberStyle: NumberFormatter.Style,
        decimalPlaces: Int
    ) -> String?

    /// Formats a numeric value according to the specified style
    /// - Parameters:
    ///   - value: The number to format
    ///   - numberStyle: The number formatting style to apply
    ///   - decimalPlaces: The number of decimal places in the formatted output
    /// - Returns: A formatted string representation of the number
    func format(
        _ value: Double,
        numberStyle: NumberFormatter.Style,
        decimalPlaces: Int
    ) -> String?

}
