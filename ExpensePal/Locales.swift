//
//  Locales.swift
//  ExpensePal
//
//  Created by Gokul P on 20/10/24.
//

import Foundation

enum Locales {
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
}
