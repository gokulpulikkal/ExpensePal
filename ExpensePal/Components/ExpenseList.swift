//
//  ExpenseList.swift
//  ExpensePal
//
//  Created by Gokul P on 22/06/24.
//

import SwiftData
import SwiftUI
import SwipeActions
import ExpensePalModels

struct ExpenseList: View {
    var queryDescriptor: FetchDescriptor<Expense>
    var searchText: String
    @Environment(\.modelContext) var modelContext
    @Query var expenseList: [Expense]
    private var columns = [
        GridItem(.adaptive(minimum: 360, maximum: 360), spacing: 50)
    ]

    init(queryDescriptor: FetchDescriptor<Expense>, searchText: String) {
        self.queryDescriptor = queryDescriptor
        _expenseList = Query(queryDescriptor)
        self.searchText = searchText
    }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    Section {
                        // Here goes the items
                        ForEach(searchResults, id: \.id) { expense in
                            ExpenseListCell(expense: expense)
                                .padding(.vertical, 5)
                        }
                    }
                }
                .animation(.bouncy, value: expenseList)
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
            expenseList
        } else {
            expenseList
                .filter {
                    $0.title.localizedStandardContains(searchText) || $0.subTitle.localizedStandardContains(searchText)
                }
        }
    }
}

#if DEBUG
#Preview {
    ExpenseList(queryDescriptor: Expense.getFetchDescriptorForFilter(.thisMonth), searchText: "")
        .modelContainer(previewContainer)
}
#endif
