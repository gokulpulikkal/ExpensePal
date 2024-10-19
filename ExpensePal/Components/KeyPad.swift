//
//  KeyPad.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct KeyPad: View {

    @Binding var string: String

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0..<12) { i in
                    Button(action: {
                        keyWasPressed(getKeyText(i))
                    }) {
                        Text(getKeyText(i))
                            .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                            .font(.system(size: 30))
                            .frame(
                                width: min(max(geometry.size.width / 3 - 15, 0), 80),
                                height: min(max(geometry.size.width / 3 - 15, 0), 80)
                            )
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    private func getKeyText(_ index: Int) -> String {
        switch index {
        case 0:
            "1"
        case 1:
            "2"
        case 2:
            "3"
        case 3:
            "4"
        case 4:
            "5"
        case 5:
            "6"
        case 6:
            "7"
        case 7:
            "8"
        case 8:
            "9"
        case 9:
            "."
        case 10:
            "0"
        case 11:
            "⌫"
        default:
            "0"
        }
    }

    private func keyWasPressed(_ key: String) {
        if key == "⌫" {
            string.removeLast()
        } else {
            string += key
        }
    }
}

#Preview {
    KeyPad(string: .constant("0"))
}
