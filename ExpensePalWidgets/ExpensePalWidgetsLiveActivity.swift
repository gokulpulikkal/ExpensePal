//
//  ExpensePalWidgetsLiveActivity.swift
//  ExpensePalWidgets
//
//  Created by Gokul P on 12/22/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ExpensePalWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ExpensePalWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ExpensePalWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ExpensePalWidgetsAttributes {
    fileprivate static var preview: ExpensePalWidgetsAttributes {
        ExpensePalWidgetsAttributes(name: "World")
    }
}

extension ExpensePalWidgetsAttributes.ContentState {
    fileprivate static var smiley: ExpensePalWidgetsAttributes.ContentState {
        ExpensePalWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ExpensePalWidgetsAttributes.ContentState {
         ExpensePalWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ExpensePalWidgetsAttributes.preview) {
   ExpensePalWidgetsLiveActivity()
} contentStates: {
    ExpensePalWidgetsAttributes.ContentState.smiley
    ExpensePalWidgetsAttributes.ContentState.starEyes
}
