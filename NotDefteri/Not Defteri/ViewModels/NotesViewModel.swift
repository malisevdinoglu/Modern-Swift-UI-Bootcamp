//
//  NotesViewModel.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//

import Foundation

final class NotesViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []

    private let storageKey = "notes_storage_v1"
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        // Tarihlerin okunaklı saklanması şart değil ama debug kolaylığı sağlar
        encoder.outputFormatting = [.prettyPrinted]
        load()
    }

    // MARK: - Persistence
    func load() {
        guard let data = defaults.data(forKey: storageKey) else { return }
        do {
            let decoded = try decoder.decode([Note].self, from: data)
            notes = decoded.sorted(by: { $0.date > $1.date })
        } catch {
            print("⚠️ Decode failed:", error)
            notes = []
        }
    }

    private func persist() {
        do {
            let data = try encoder.encode(notes)
            defaults.set(data, forKey: storageKey)
        } catch {
            print("⚠️ Encode failed:", error)
        }
    }

    // MARK: - CRUD
    func add(title: String, content: String) {
        let new = Note(title: title, content: content, date: Date())
        notes.insert(new, at: 0) // En üste gelsin
        persist()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        persist()
    }

    func update(_ note: Note, title: String, content: String) {
        if let i = notes.firstIndex(where: { $0.id == note.id }) {
            notes[i].title = title
            notes[i].content = content
            notes[i].date = Date() // Düzenlendiğinde tarihi güncelle
            persist()
        }
    }

    func noteById(_ id: UUID) -> Note? {
        notes.first(where: { $0.id == id })
    }
}
