//
//  ExpenseListView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct ExpenseListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            pageTitle
                .padding(.vertical)
            ExpenseSearchView()
                .padding(.top, -20)
        }
        .padding(.horizontal)
    }
    
    var pageTitle: some View {
        HStack {
            Text("All Expenses")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    ExpenseListView()
        .modelContainer(previewContainer)
}
#endif
