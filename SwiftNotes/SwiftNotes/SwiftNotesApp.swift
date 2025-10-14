//
//  SwiftNotesApp.swift
//  SwiftNotes
//
//  Created by Mehmet Ali Sevdinoğlu on 14.10.2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftNotesApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        
        // App Group ID'nizi buraya yazın
        let appGroupID = "group.com.mali.SwiftNotes"
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!.appendingPathComponent("SwiftNotes.sqlite")
        
        let modelConfiguration = ModelConfiguration(schema: schema, url: containerURL)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
