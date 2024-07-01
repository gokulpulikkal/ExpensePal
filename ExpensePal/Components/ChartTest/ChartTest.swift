//
//  ChartTest.swift
//  ExpensePal
//
//  Created by Gokul P on 29/06/24.
//

import Charts
import SwiftUI

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

struct ChartTest: View {
    var data: [ToyShape] = [
        .init(type: "Cube", count: 5),
        .init(type: "Sphere", count: 4),
        .init(type: "Pyramid", count: 6),
    ]

    var body: some View {
        Chart {
            ForEach(data) { shape in
                LineMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Total Count", shape.count)
                )
                .interpolationMethod(.catmullRom)
            }
        }
        
        .chartYScale(domain: [3, 7])
        .padding()
    }
}

#Preview {
    ChartTest()
}
