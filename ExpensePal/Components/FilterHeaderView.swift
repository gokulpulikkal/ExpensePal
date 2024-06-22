//
//  FilterHeaderView.swift
//  ExpensePal
//
//  Created by Gokul P on 11/06/24.
//

import SwiftUI

struct FilterHeaderView: View {
    @Binding var chartFilter: ExpenseChartFilter
    @Binding var didTapSearchIcon: Bool

    var body: some View {
        HStack(spacing: 20) {
            Menu {
                ForEach(ExpenseChartFilter.allCases) { filter in
                    if filter != .yearly { //Year filter is disabled for now
                        Button(filter.description) {
                            chartFilter = filter
                        }
                        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                        .padding(.vertical)
                    }
                }
            } label: {
                RoundedStrokeButton(text: Text(chartFilter.description), image: Image(systemName: "chevron.down"), action: {
                })
            }
            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    didTapSearchIcon = true
                }
        }
    }
}

#Preview {
    FilterHeaderView(chartFilter: .constant(.daily), didTapSearchIcon: .constant(false) )
}
