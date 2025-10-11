//
//  FavoriteLocation.swift
//  HaritaUygulama
//
//  Created by Mehmet Ali Sevdinoğlu on 10.10.2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteLocation {
    var name: String
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(name: String, latitude: Double, longitude: Double, timestamp: Date) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
