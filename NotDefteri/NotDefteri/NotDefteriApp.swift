//
//  NotDefteriApp.swift
//  NotDefteri
//
//  Created by Mehmet Ali Sevdinoğlu on 17.09.2025.
//

import SwiftUI

@main
struct NotDefteriApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
