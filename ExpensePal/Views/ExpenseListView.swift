//
//  ExpenseListView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct ExpenseListView: View {
    var body: some View {
        VStack {
            pageTitle
            ExpenseSearchView()
                .padding(.vertical, -20)
        }
    }
    
    var pageTitle: some View {
        HStack {
            Text("All Expenses")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ExpenseListView()
        .modelContainer(previewContainer)
}
