//
//  LinePlotEntry.swift
//  ExpensePal
//
//  Created by Gokul P on 18/06/24.
//

import SwiftUI

struct LinePlotEntry: Identifiable {
    let xValueType: String
    let yValueType: String
    
    let xValue: Date
    let yValue: Double
    
    var id = UUID()
}
