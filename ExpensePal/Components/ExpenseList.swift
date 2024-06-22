//
//  ExpenseList.swift
//  ExpensePal
//
//  Created by Gokul P on 22/06/24.
//

import SwiftData
import SwiftUI

struct ExpenseList: View {
    var queryDescriptor: FetchDescriptor<Expense>
    var searchText: String
    @Query var expenseList: [Expense]

    init(queryDescriptor: FetchDescriptor<Expense>, searchText: String) {
        self.queryDescriptor = queryDescriptor
        _expenseList = Query(queryDescriptor)
        self.searchText = searchText
    }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 18) {
                    Section {
                        // Here goes the items
                        ForEach(searchResults, id: \.id) { expense in
                            ExpenseListCell(expense: expense)
                        }
                    }
                }
                .padding()
            }
            if searchResults.count <= 0 {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .symbolEffect(.bounce, options: .repeat(3), value: searchResults)
                        .aspectRatio(1.1, contentMode: .fit)
                        .frame(width: 100)

                    Text("No results Found")
                        .bold()
                }
            }
        }
    }

    var searchResults: [Expense] {
        if searchText.isEmpty {
            return expenseList
        } else {
            return expenseList.filter { $0.title.localizedStandardContains(searchText) || $0.subTitle.localizedStandardContains(searchText) }
        }
    }
}

#Preview {
    ExpenseList(queryDescriptor: Expense.getFetchDescriptorForFilter(.thisMonth), searchText: "").modelContainer(previewContainer)
}
