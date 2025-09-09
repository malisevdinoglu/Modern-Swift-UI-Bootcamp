//
//  EventStore.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import Foundation

final class EventStore: ObservableObject {
    @Published var events: [Event] = [] {
        didSet { save() }
    }

    private let storageKey = "EventStore.events"

    init(useSamplesIfEmpty: Bool = true) {
        load()
        if useSamplesIfEmpty && events.isEmpty {
            events = Event.samples
        }
    }

    // MARK: - CRUD
    func add(title: String, date: Date, type: EventType, hasReminder: Bool) {
        let newEvent = Event(title: title, date: date, type: type, hasReminder: hasReminder)
        events.append(newEvent)
    }

    func delete(id: UUID) {
        events.removeAll { $0.id == id }
    }

    func toggleReminder(id: UUID) {
        guard let i = events.firstIndex(where: { $0.id == id }) else { return }
        events[i].hasReminder.toggle()
    }

    func update(_ event: Event) {
        guard let i = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[i] = event
    }

    // MARK: - Persistence (UserDefaults)
    private func save() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Event].self, from: data) else {
            events = []
            return
        }
        events = decoded
    }
}
