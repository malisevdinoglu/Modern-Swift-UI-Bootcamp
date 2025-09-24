//
//  APIExplorerApp.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import SwiftUI

@main
struct APIExplorerApp: App {
    @StateObject private var favorites = FavoritesStore()
    init() {
       
        URLCache.shared.memoryCapacity = 50 * 1024 * 1024
        URLCache.shared.diskCapacity   = 200 * 1024 * 1024
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CharacterListView()
            }
            .environmentObject(favorites)
        }
    }
}
