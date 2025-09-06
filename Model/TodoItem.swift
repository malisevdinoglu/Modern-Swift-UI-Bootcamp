//
//  TodoItem.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var detail: String
    var isDone: Bool

    init(id: UUID = UUID(), title: String, detail: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.detail = detail
        self.isDone = isDone
    }
}
