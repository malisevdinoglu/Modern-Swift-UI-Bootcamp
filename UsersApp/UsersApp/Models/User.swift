//
//  User.swift
//  UsersApp
//
//  Created by Mehmet Ali Sevdinoğlu on 18.09.2025.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

extension User {
    // Her kullanıcı için sabit bir (örnek) avatar üretir
    var avatarURL: URL { URL(string: "https://i.pravatar.cc/150?u=\(id)")! }
}
