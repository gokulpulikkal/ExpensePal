//
//  RoundedStrokeButton.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct RoundedStrokeButton: View {
    let text: Text
    let image: Image
    var body: some View {
        Button(action: {}) {
            HStack {
                text
                image
            }
        }
        .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background {
            Capsule(style: .circular)
                .stroke(lineWidth: 1)
        }.bold()
    }
}

#Preview {
    RoundedStrokeButton(text: Text("this month"), image: Image(systemName: "chevron.down"))
}
