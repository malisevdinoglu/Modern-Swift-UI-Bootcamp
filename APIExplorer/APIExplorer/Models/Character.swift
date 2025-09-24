//
//  Character.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//
import Foundation

struct CharactersResponse: Codable {
    let info: PageInfo
    let results: [Character]
}

struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// Yardımcı tipler
struct NamedLink: Codable, Hashable {
    let name: String
    let url: String?
}

struct Character: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: URL

    // Detayda kullanacağımız (liste yanıtında da geliyor) alanlar:
    let gender: String?
    let origin: NamedLink?
    let location: NamedLink?
    let episode: [URL]?
}
