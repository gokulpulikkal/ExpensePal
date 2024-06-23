//
//  DarkModeViewModifier.swift
//  ExpensePal
//
//  Created by Gokul P on 22/06/24.
//

import SwiftUI

struct DarkModeViewModifier: ViewModifier {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true

    public func body(content: Content) -> some View {
        content
            .preferredColorScheme(isDarkMode ? .dark : isDarkMode == false ? .light : nil)
    }
}
