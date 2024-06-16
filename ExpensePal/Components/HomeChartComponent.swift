//
//  HomeChartComponent.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct HomeChartComponent: View {
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .background(.green)
            Text(301.96, format: .currency(code: "USD"))
                .bold()
                .font(.largeTitle)
            
        }
        
    }
}

#Preview {
    HomeChartComponent()
}
