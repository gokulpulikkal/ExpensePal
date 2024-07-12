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
            return "1"
        case 1:
            return "2"
        case 2:
            return "3"
        case 3:
            return "4"
        case 4:
            return "5"
        case 5:
            return "6"
        case 6:
            return "7"
        case 7:
            return "8"
        case 8:
            return "9"
        case 9:
            return "."
        case 10:
            return "0"
        case 11:
            return "⌫"
        default:
            return "0"
        }
    }

    private func keyWasPressed(_ key: String) {
        switch key {
        case "." where string == "0":
            string = "0."
        case "." where !string.contains("."):
            string += "."
        case "⌫":
            if string.count > 1 {
                let last = string.removeLast()
                if last == "." {
                    string.removeLast()
                }
            } else {
                string = "0"
            }
        case _ where string == "0":
            string = key
        default:
            if string.contains(".") {
                let split = string.split(separator: ".")
                if split.count > 1, split[1].count > 1 {
                    return
                }
            }
            string += key
        }
    }
}

#Preview {
    KeyPad(string: .constant("0"))
}
