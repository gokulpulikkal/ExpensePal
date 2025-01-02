//
//  ExpensePalWidgets.swift
//  ExpensePalWidgets
//
//  Created by Gokul P on 12/22/24.
//

import ExpensePalModels
import SwiftData
import SwiftUI
import WidgetKit

struct ExpensePalWidgets: Widget {
    let kind = "ExpensePalWidgets"

    let container: ModelContainer

    init() {
        do {
            self.container = try ModelContainer(for: Expense.self)
            SwiftDataServiceForAppIntents.shared.modelContext = container.mainContext
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { _ in
            ExpensePalWidgetsEntryView()
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(container)
        }
    }
}

#Preview(as: .systemSmall) {
    ExpensePalWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
