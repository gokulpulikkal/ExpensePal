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
            HStack {
                Text("this month")
                Image(systemName: "chevron.down")
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background {
                Capsule(style: .circular)
                    .stroke(lineWidth: 1)
            }
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

#Preview {
    FilterHeaderView()
}
