//
//  ContentView.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = NotesViewModel()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.notes.isEmpty {
                    ContentUnavailableView(
                        "Henüz not yok",
                        systemImage: "note.text",
                        description: Text("Yeni not eklemek için sağ üstteki + butonuna dokun.")
                    )
                } else {
                    List {
                        ForEach(vm.notes) { note in
                            NavigationLink(value: note) {
                                NoteRow(note: note)
                            }
                        }
                        .onDelete(perform: vm.delete) // Bonus: Silme
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Not Defteri")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityLabel("Yeni Not Ekle")
                }
            }
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(note: note, vm: vm)
            }
            .sheet(isPresented: $showingAdd) {
                AddNoteView(vm: vm)
            }
        }
    }
}
