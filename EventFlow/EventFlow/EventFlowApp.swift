//
//  EventFlowApp.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

@main
struct EventFlowApp: App {
    @StateObject private var store = EventStore()

    var body: some Scene {
        WindowGroup {
            EventListView()
                .environmentObject(store)
        }
    }
}

