//
//  Note.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//

import Foundation

struct Note: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var content: String
    var date: Date

    init(id: UUID = UUID(), title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
