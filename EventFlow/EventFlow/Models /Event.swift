//
//  Event.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var type: EventType
    var hasReminder: Bool

    init(id: UUID = UUID(), title: String, date: Date, type: EventType, hasReminder: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.hasReminder = hasReminder
    }
}

extension Event {
    static var samples: [Event] {
        [
            Event(title: "iOS Toplantısı", date: Date().addingTimeInterval(60*60*24), type: .toplanti, hasReminder: true),
            Event(title: "Kardeşimin Doğum Günü", date: Date().addingTimeInterval(60*60*24*5), type: .dogumGunu, hasReminder: false),
            Event(title: "Hafta Sonu Tatili", date: Date().addingTimeInterval(60*60*24*10), type: .tatil, hasReminder: false)
        ]
    }
}
