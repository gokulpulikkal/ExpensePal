//
//  KeyPad.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import SwiftUI

struct KeyPad: View {
    @Binding var string: String

    var body: some View {
        VStack(spacing: 20) {
            KeyPadRow(keys: ["1", "2", "3"])
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: [".", "0", "⌫"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
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

struct KeyPadRow: View {
    var keys: [String]

    var body: some View {
        HStack(spacing: 30) {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}
