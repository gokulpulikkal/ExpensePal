//
//  ExpenseSearchView.swift
//  ExpensePal
//
//  Created by Gokul P on 22/06/24.
//

import SwiftData
import SwiftUI

struct ExpenseSearchView: View {
    @State var searchText: String = ""
    @State var selectedDate: Date = Date.now
    @State var selectedFilter: ExpenseSearchFilter = ExpenseSearchFilter.thisMonth

    var body: some View {
        headerView
            .padding(.top, 20)
        ExpenseList(queryDescriptor: Expense.getFetchDescriptorForFilter(selectedFilter), searchText: searchText)
        Spacer()
    }

    var headerView: some View {
        HStack {
            TextField("", text: $searchText, prompt: Text("Search For Expense").foregroundColor(.gray))
                .frame(width: 300)
                .font(.system(size: 15))
                .bold()
                .padding(12)
                .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
                .background(Color(AppColors.primaryAccent.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Menu {
                ForEach(ExpenseSearchFilter.allCases) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }, label: {
                        HStack {
                            Text(filter.description)
                            if filter == selectedFilter {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    })
                    .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                    .padding(.vertical)
                }
            } label: {
                Image(systemName: "calendar.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        }
    }
}

#Preview {
    ExpenseSearchView()
        .modelContainer(previewContainer)
}
