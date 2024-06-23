//
//  DarkModeViewModifier.swift
//  ExpensePal
//
//  Created by Gokul P on 22/06/24.
//

import SwiftUI

struct DarkModeViewModifier: ViewModifier {
    @AppStorage("isLightMode") var isLightMode: Bool = true

    public func body(content: Content) -> some View {
        content
            .preferredColorScheme(isLightMode ? .light : isLightMode == false ? .dark : nil)
    }
}
