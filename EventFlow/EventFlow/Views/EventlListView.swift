//
//  EventlListView.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var store: EventStore
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                if store.events.isEmpty {
                    ContentUnavailableView(
                        "Henüz etkinlik yok",
                        systemImage: "calendar",
                        description: Text("Yeni etkinlik eklemek için + butonuna dokunun.")
                    )
                } else {
                    ForEach(store.events) { event in
                        NavigationLink {
                            EventDetailView(eventID: event.id)
                        } label: {
                            EventRowView(event: event)
                        }
                    }
                }
            }
            .navigationTitle("Etkinlikler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni Etkinlik Ekle")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEventView()
                    .environmentObject(store)
            }
        }
    }
}

#Preview {
    EventListView().environmentObject(EventStore())
}
