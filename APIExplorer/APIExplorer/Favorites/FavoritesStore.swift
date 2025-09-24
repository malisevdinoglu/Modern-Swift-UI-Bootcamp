//
//  FavoritesStore.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//
import Foundation
import SwiftUI

struct FavoriteSnapshot: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let image: URL
}

final class FavoritesStore: ObservableObject {
    @Published private(set) var items: [FavoriteSnapshot] = [] {
        didSet { save() }
    }

    private let key = "favorites_v1"

    init() { load() }

    func isFavorite(id: Int) -> Bool {
        items.contains { $0.id == id }
    }

    func toggle(character: Character) {
        if let idx = items.firstIndex(where: { $0.id == character.id }) {
            items.remove(at: idx)
        } else {
            let snap = FavoriteSnapshot(id: character.id,
                                        name: character.name,
                                        image: character.image)
            items.append(snap)
        }
    }

    func remove(id: Int) {
        items.removeAll { $0.id == id }
    }

    // MARK: - Persistence
    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Favorites save error:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            items = try JSONDecoder().decode([FavoriteSnapshot].self, from: data)
        } catch {
            print("Favorites load error:", error)
            items = []
        }
    }
}
