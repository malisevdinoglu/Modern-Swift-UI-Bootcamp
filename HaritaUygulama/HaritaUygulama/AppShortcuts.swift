//
//  AppShortcuts.swift
//  HaritaUygulama
//
//  Created by Mehmet Ali Sevdinoğlu on 11.10.2025.
//

import AppIntents

struct ShowCurrentLocationIntent: AppIntent {
   
    static var title: LocalizedStringResource = "Mevcut Konumu Göster"
    
    
    static var openAppWhenRun: Bool = true
    

    @MainActor
    func perform() async throws -> some IntentResult {

        NavigationManager.shared.selectedTab = .map
        return .result()
    }
}


struct ShowFavoritesIntent: AppIntent {
    static var title: LocalizedStringResource = "Favorileri Göster"
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
       
        NavigationManager.shared.selectedTab = .favorites
        return .result()
    }
}



struct LocationAppShortcuts: AppShortcutsProvider {
    
 
    static var appShortcuts: [AppShortcut] {
        
        AppShortcut(
            intent: ShowCurrentLocationIntent(),
            phrases: [
                "\(.applicationName) içinde mevcut konumumu göster",
                "\(.applicationName) içinde haritayı aç"
            ],
            shortTitle: "Konumu Göster",
            systemImageName: "map.fill"
        )
        
        AppShortcut(
            intent: ShowFavoritesIntent(),
            phrases: [
                "\(.applicationName) içinde favorilerimi aç",
                "\(.applicationName) içinde favori konumlarımı göster"
            ],
            shortTitle: "Favorileri Aç",
            systemImageName: "star.fill"
        )
    }
}
