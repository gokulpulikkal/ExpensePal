//
//  LinePlotEntry.swift
//  ExpensePal
//
//  Created by Gokul P on 18/06/24.
//

import Charts
import SwiftUI

public struct LinePlotEntry: Identifiable, Equatable, Plottable {
    public let xValueType: String
    public let yValueType: String

    public let xValue: Date
    public let yValue: Double

    public var id = UUID()

    public init(xValueType: String, yValueType: String, xValue: Date, yValue: Double, id: UUID = UUID()) {
        self.xValueType = xValueType
        self.yValueType = yValueType
        self.xValue = xValue
        self.yValue = yValue
        self.id = id
    }

    public var primitivePlottable: Date { xValue }
    
    public init?(primitivePlottable: Date) {
        // This probably doesn't make sense, but is the best we can
        // do here.
        nil
    }
}
