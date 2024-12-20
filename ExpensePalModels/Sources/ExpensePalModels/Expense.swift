//
//  Expense.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Foundation
import SwiftData

@Model
public class Expense: Codable {
    public var id = UUID()
    public var emoji: String = ""
    public var title: String = ""
    public var subTitle: String = ""
    public var cost: Double = 0
    public var date: Date = Date()
    public var locale: String = "USA"

    public init(id: UUID = UUID(), emoji: String, title: String, subTitle: String = "", cost: Double, date: Date = .now, locale: String = "USA") {
        self.id = id
        self.emoji = emoji
        self.title = title
        self.subTitle = subTitle
        self.cost = cost
        self.date = date
        self.locale = locale
    }

    enum ExpenseCodingKeys: CodingKey {
        case id
        case emoji
        case title
        case subTitle
        case cost
        case date
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExpenseCodingKeys.self)
        id = UUID()
        emoji = try container.decode(String.self, forKey: .emoji)
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        cost = try container.decode(Double.self, forKey: .cost)
        date = try container.decode(Date.self, forKey: .date)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ExpenseCodingKeys.self)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(title, forKey: .title)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(cost, forKey: .cost)
        try container.encode(id, forKey: .id)
    }
}
