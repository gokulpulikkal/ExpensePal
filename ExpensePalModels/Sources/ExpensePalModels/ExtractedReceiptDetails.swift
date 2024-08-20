//
//  ExtractedReceiptDetails.swift
//  ExpensePal
//
//  Created by Gokul P on 29/07/24.
//

import Foundation

public struct ExtractedReceiptDetails: Codable {
    public let extractedLines: [String]
    
    public init(extractedLines: [String]) {
        self.extractedLines = extractedLines
    }
}
