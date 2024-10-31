//
//  OpenDashboard.swift
//  ExpensePal
//
//  Created by Gokul P on 30/10/24.
//

import AppIntents

struct OpenDashboard: AppIntent {
    
    static var title: LocalizedStringResource = "Open ExpensePal dashboard"


    static var description = IntentDescription("Opens the app and goes to your dashboard.")
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
