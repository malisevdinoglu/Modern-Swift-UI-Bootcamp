//
//  NoteDetailView.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//

import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let note: Note
    @ObservedObject var vm: NotesViewModel

    @State private var isEditing = false
    @State private var title: String
    @State private var content: String
    @State private var shownDate: Date

    init(note: Note, vm: NotesViewModel) {
        self.note = note
        self.vm = vm
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
        _shownDate = State(initialValue: note.date)
    }

    var body: some View {
        Form {
            Section {
                TextField("Başlık", text: $title)
                    .disabled(!isEditing)
                HStack {
                    Label("Tarih", systemImage: "calendar")
                    Spacer()
                    Text(shownDate.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }
            Section("İçerik") {
                TextEditor(text: $content)
                    .frame(minHeight: 220)
                    .disabled(!isEditing)
            }
        }
        .navigationTitle("Not")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Kaydet") {
                        vm.update(note, title: title, content: content)
                        shownDate = Date() // ekranda da güncellenmiş tarihi göster
                        isEditing = false
                    }
                } else {
                    Button("Düzenle") { isEditing = true }
                }
            }
        }
    }
}
