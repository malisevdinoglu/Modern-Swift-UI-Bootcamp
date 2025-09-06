//
//  MasterListAppApp.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import SwiftUI

@main
struct MasterListAppApp: App {
    @StateObject private var vm = ListViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
