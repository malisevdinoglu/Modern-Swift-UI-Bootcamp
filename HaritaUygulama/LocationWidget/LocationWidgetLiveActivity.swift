//
//  LocationWidgetLiveActivity.swift
//  LocationWidget
//
//  Created by Mehmet Ali Sevdinoğlu on 11.10.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LocationWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LocationWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LocationWidgetAttributes.self) { context in
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

extension LocationWidgetAttributes {
    fileprivate static var preview: LocationWidgetAttributes {
        LocationWidgetAttributes(name: "World")
    }
}

extension LocationWidgetAttributes.ContentState {
    fileprivate static var smiley: LocationWidgetAttributes.ContentState {
        LocationWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LocationWidgetAttributes.ContentState {
         LocationWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LocationWidgetAttributes.preview) {
   LocationWidgetLiveActivity()
} contentStates: {
    LocationWidgetAttributes.ContentState.smiley
    LocationWidgetAttributes.ContentState.starEyes
}
