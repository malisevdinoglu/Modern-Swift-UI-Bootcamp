//
//  NavigationManager.swift
//  HaritaUygulama
//
//  Created by Mehmet Ali Sevdinoğlu on 11.10.2025.
//

import Foundation
import Combine


enum Tab {
    case map
    case favorites
}

class NavigationManager: ObservableObject {
  
    @Published var selectedTab: Tab = .map
    

    static let shared = NavigationManager()
    
    
    private init() {}
}
