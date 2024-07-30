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

    var body: some View {
        if !showingSplash {
            HomeTabView()
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
                    .padding(.top, -20)

                Text("Expense Pal")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color(AppColors.primaryAccent.rawValue))
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
