//
//  LaunchScreen.swift
//  ExpensePal
//
//  Created by Gokul P on 30/07/24.
//

import SwiftUI

struct LaunchScreen: View {

    @State var showingSplash = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if !showingSplash {
            if horizontalSizeClass == .compact {
                HomeTabView()
            } else {
                RegularHomeTabView()
            }
        } else {
            splashScreen
                .task {
                    do {
                        try await createDelay()
                    } catch {
                        print("couldn't create delay!! \(error.localizedDescription)")
                    }
                    showingSplash = false
                }
        }
        
    }

    var splashScreen: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Color(AppColors.primaryBackground.rawValue))
            VStack {
                Image(colorScheme == .dark ? "splashDark" : "splashLight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text("Expense Pal")
                    .font(.system(size: horizontalSizeClass == .compact ? 40: 70, weight: .heavy))
                    .bold()
                    .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
                    .padding(.bottom, 30)
            }
        }
    }
    
    func createDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64(1.5 * Double(NSEC_PER_SEC)))
    }
}

#Preview {
    LaunchScreen()
}
