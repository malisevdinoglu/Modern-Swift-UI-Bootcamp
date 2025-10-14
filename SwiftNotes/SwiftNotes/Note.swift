//
//  Item.swift
//  SwiftNotes
//
//  Created by Mehmet Ali Sevdinoğlu on 14.10.2025.
//
import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var content: String
    var createdAt: Date
    
    init(title: String, content: String, createdAt: Date) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
