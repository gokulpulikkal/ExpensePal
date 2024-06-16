//
//  ExpenseListCell.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct ExpenseListCell: View {
    var body: some View {
        HStack {
            Text("🐶")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("pet care")
                    .bold()
                Text("petco")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text("-$308")
                .bold()
        }
    }
}

#Preview {
    ExpenseListCell()
}
