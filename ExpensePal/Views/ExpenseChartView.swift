//
//  ExpenseChartView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import Charts
import SwiftUI

struct ExpenseChartView: View {
    var body: some View {
        pageTitle
        Spacer()
    }

    var pageTitle: some View {
        HStack {
            Text("Report")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ExpenseChartView()
}
