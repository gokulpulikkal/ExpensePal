//
//  Locales.swift
//  ExpensePal
//
//  Created by Gokul P on 20/10/24.
//

import Foundation

enum Locales: String {
    case USA
    case EUROPE
    case CANADA
    case INDIA

    var localeIdentifier: String {
        switch self {
        case .USA:
            "en_US"
        case .EUROPE:
            "de_DE"
        case .CANADA:
            "en_CA"
        case .INDIA:
            "en_IN"
        }
    }

    init?(localeIdentifier: String) {
        switch localeIdentifier {
        case "en_US":
            self = .USA
        case "de_DE":
            self = .EUROPE
        case "en_CA":
            self = .CANADA
        case "en_IN":
            self = .INDIA
        default:
            return nil
        }
    }

    var currency: Currency {
        switch self {
        case .USA:
            .USD
        case .EUROPE:
            .EUR
        case .CANADA:
            .CAD
        case .INDIA:
            .INR
        }
    }
}
