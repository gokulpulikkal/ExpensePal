//
//  MockData.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Foundation

struct MockData {
    func getMockDataFromJSON() -> [Expense] {
        guard let url = Bundle.main.url(forResource: "ExpensesMockData", withExtension: "json") else {
            print("Did not find file")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let expenses = try decoder.decode([Expense].self, from: data)
            return expenses
        } catch {
            print("Failed to load Expense.")
        }
        return []
    }
}
