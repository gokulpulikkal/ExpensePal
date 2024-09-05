//
//  GenAIResponse.swift
//  ExpensePal
//
//  Created by Gokul P on 29/07/24.
//

import Foundation

public struct GenAIResponse: Codable {
    public var emoji: String
    public var title: String
    public var subTitle: String
    public var cost: Double
    public var date: Date
}
