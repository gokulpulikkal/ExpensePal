//
//  FilterHeaderView.swift
//  ExpensePal
//
//  Created by Gokul P on 11/06/24.
//

import SwiftUI

struct FilterHeaderView: View {
    var body: some View {
        HStack(spacing: 20) {
            RoundedStrokeButton(text: Text("this month"), image: Image(systemName: "chevron.down"))
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

#Preview {
    FilterHeaderView()
}
