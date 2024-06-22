//
//  ExpenseListView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct ExpenseListView: View {
    var body: some View {
        ExpenseSearchView()
    }
}

#Preview {
    ExpenseListView()
        .modelContainer(previewContainer)
}
