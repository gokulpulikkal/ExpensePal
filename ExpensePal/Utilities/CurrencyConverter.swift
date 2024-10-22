//
//  CurrencyConverter.swift
//  ExpensePal
//
//  Created by Gokul P on 22/10/24.
//

import Foundation

/// Global Enumerations:
enum Currency: String, CaseIterable {

    case AUD
    case INR
    case TRY
    case BGN
    case ISK
    case USD
    case BRL
    case JPY
    case ZAR
    case CAD
    case KRW
    case CHF
    case MXN
    case CNY
    case MYR
    case CZK
    case NOK
    case DKK
    case NZD
    case EUR
    case PHP
    case GBP
    case PLN
    case HKD
    case RON
    case HRK
    case RUB
    case HUF
    case SEK
    case IDR
    case SGD
    case ILS
    case THB
}

/// Global Classes:
class CurrencyConverter {

    /// Singleton
    static let shared = CurrencyConverter()

    // Private Properties:
    private var exchangeRates: [Currency: Double] = [:]
    private let xmlParser = CurrencyXMLParser()

    /// Initialization:
    private init() {}

    /// Public Methods:
    /// Updates the exchange rate and runs the completion afterwards.
    public func updateExchangeRates() async {
        do {
            try await xmlParser.parse()
            // Gets the exchange rate from the internet:
            self.exchangeRates = self.xmlParser.getExchangeRates()
            // Saves the updated exchange rate to the device's local storage:
            CurrencyConverterLocalData.saveMostRecentExchangeRates(self.exchangeRates)
        } catch {
            print("Error Loading the latest Exchange rates!!!")
            // Loads the most recent exchange rate from the device's local storage:
            self.exchangeRates = CurrencyConverterLocalData.loadMostRecentExchangeRates()
        }
    }

    /// Converts a Double value based on it's currency (valueCurrency) and the output currency (outputCurrency).
    /// USD to EUR conversion example: convert(42, valueCurrency: .USD, outputCurrency: .EUR)
    public func convert(_ value: Double, valueCurrency: Currency, outputCurrency: Currency) -> Double? {
        guard let valueRate = exchangeRates[valueCurrency] else {
            return nil
        }
        guard let outputRate = exchangeRates[outputCurrency] else {
            return nil
        }
        let multiplier = outputRate / valueRate
        return value * multiplier
    }

    /// Converts a Double value based on it's currency and the output currency, and returns a formatted String.
    /// Usage example: convertAndFormat(42, valueCurrency: .USD, outputCurrency: .EUR, numberStyle: .currency,
    /// decimalPlaces: 4)
    public func convertAndFormat(
        _ value: Double,
        valueCurrency: Currency,
        outputCurrency: Currency,
        numberStyle: NumberFormatter.Style,
        decimalPlaces: Int
    ) -> String? {
        guard let doubleOutput = convert(value, valueCurrency: valueCurrency, outputCurrency: outputCurrency) else {
            return nil
        }
        return format(doubleOutput, numberStyle: numberStyle, decimalPlaces: decimalPlaces)
    }

    /// Returns a formatted string from a double value.
    /// Usage example: format(42, numberStyle: .currency, decimalPlaces: 4)
    public func format(_ value: Double, numberStyle: NumberFormatter.Style, decimalPlaces: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: NSNumber(value: value))
    }

}

/// Private Classes:
private class CurrencyXMLParser: NSObject, XMLParserDelegate {

    // Private Properties:
    private let xmlURL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    private var exchangeRates: [Currency: Double] = [
        .EUR: 1.0 // Base currency
    ]

    /// Public Methods:
    public func getExchangeRates() -> [Currency: Double] {
        exchangeRates
    }

    public func parse() async throws {
        guard let url = URL(string: xmlURL) else {
            return
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    /// Private Methods:
    private func makeExchangeRate(currency: String, rate: String) -> (currency: Currency, rate: Double)? {
        guard let currency = Currency(rawValue: currency) else {
            return nil
        }
        guard let rate = Double(rate) else {
            return nil
        }
        return (currency, rate)
    }

    /// XML Parse Methods (from XMLParserDelegate):
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        if elementName == "Cube" {
            guard let currency = attributeDict["currency"] else {
                return
            }
            guard let rate = attributeDict["rate"] else {
                return
            }
            guard let exchangeRate = makeExchangeRate(currency: currency, rate: rate) else {
                return
            }
            exchangeRates.updateValue(exchangeRate.rate, forKey: exchangeRate.currency)
        }
    }

}

/// Private Classes:
private class CurrencyConverterLocalData {

    /// Structs:
    enum Keys {
        static let mostRecentExchangeRates = "CurrencyConverterLocalData.Keys.mostRecentExchangeRates"
    }

    /// Static Properties:
    /// • This will never be used once the method CurrencyConverter.updateExchangeRates is called with internet access.
    /// • This is just an emergency callback, in case the user doesn't have internet access the first time running the app.
    /// Updated in: 10/22/2024.
    static let fallBackExchangeRates: [Currency: Double] = [
        .USD: 1.0658, // US Dollar
        .JPY: 164.91, // Japanese Yen
        .BGN: 1.9558, // Bulgarian Lev
        .CZK: 25.415, // Czech Koruna
        .DKK: 7.4543, // Danish Krone
        .GBP: 0.8570, // British Pound
        .HUF: 394.43, // Hungarian Forint
        .PLN: 4.3205, // Polish Zloty
        .RON: 4.9745, // Romanian Leu
        .SEK: 11.2193, // Swedish Krona
        .CHF: 0.9784, // Swiss Franc
        .ISK: 147.30, // Icelandic Krona
        .NOK: 11.5935, // Norwegian Krone
        .HRK: 7.5345, // Croatian Kuna
        .RUB: 98.4150, // Russian Ruble
        .TRY: 34.2430, // Turkish Lira
        .AUD: 1.6543, // Australian Dollar
        .BRL: 5.3984, // Brazilian Real
        .CAD: 1.4634, // Canadian Dollar
        .CNY: 7.7124, // Chinese Yuan
        .HKD: 8.3425, // Hong Kong Dollar
        .IDR: 16834.82, // Indonesian Rupiah
        .ILS: 3.9825, // Israeli Shekel
        .INR: 88.5510, // Indian Rupee
        .KRW: 1445.21, // South Korean Won
        .MXN: 18.4530, // Mexican Peso
        .MYR: 5.0845, // Malaysian Ringgit
        .NZD: 1.7843, // New Zealand Dollar
        .PHP: 60.235, // Philippine Peso
        .SGD: 1.4434, // Singapore Dollar
        .THB: 38.843, // Thai Baht
        .ZAR: 20.1534 // South African Rand
    ]

    /// Static Methods:
    /// Saves the most recent exchange rates by locally storing it.
    static func saveMostRecentExchangeRates(_ exchangeRates: [Currency: Double]) {
        let convertedExchangeRates = convertExchangeRatesForUserDefaults(exchangeRates)
        UserDefaults.standard.set(convertedExchangeRates, forKey: Keys.mostRecentExchangeRates)
    }

    /// Loads the most recent exchange rates from the local storage.
    static func loadMostRecentExchangeRates() -> [Currency: Double] {
        if let userDefaultsExchangeRates = UserDefaults.standard
            .dictionary(forKey: Keys.mostRecentExchangeRates) as? [String: Double]
        {
            convertExchangeRatesFromUserDefaults(userDefaultsExchangeRates)
        } else {
            // Fallback:
            fallBackExchangeRates
        }
    }

    /// Private Static Methods:
    /// Converts the [String : Double] dictionary with the exchange rates to a [Currency : Double] dictionary.
    private static func convertExchangeRatesFromUserDefaults(_ userDefaultsExchangeRates: [String: Double])
        -> [Currency: Double]
    {
        var exchangeRates: [Currency: Double] = [:]
        for userDefaultExchangeRate in userDefaultsExchangeRates {
            if let currency = Currency(rawValue: userDefaultExchangeRate.key) {
                exchangeRates.updateValue(userDefaultExchangeRate.value, forKey: currency)
            }
        }
        return exchangeRates
    }

    /// Converts the [Currency : Double] dictionary with the exchange rates to a [String : Double] one so it can be
    /// stored locally.
    private static func convertExchangeRatesForUserDefaults(_ exchangeRates: [Currency: Double]) -> [String: Double] {
        var userDefaultsExchangeRates: [String: Double] = [:]
        for exchangeRate in exchangeRates {
            userDefaultsExchangeRates.updateValue(exchangeRate.value, forKey: exchangeRate.key.rawValue)
        }
        return userDefaultsExchangeRates
    }

}
