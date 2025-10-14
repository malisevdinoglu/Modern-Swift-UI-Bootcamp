//
//  AddNoteView.swift
//  SwiftNotes
//
//  Created by Mehmet Ali Sevdinoğlu on 14.10.2025.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Başlık", text: $title)
                TextField("İçerik", text: $content, axis: .vertical)
            }
            .navigationTitle("Yeni Not")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveNote()
                        dismiss()
                    }
                    .disabled(title.isEmpty) // Başlık boşsa kaydet butonu pasif olsun
                }
            }
        }
    }
    
    private func saveNote() {
        let newNote = Note(title: title, content: content, createdAt: .now)
        modelContext.insert(newNote)
    }
}

#Preview {
    AddNoteView()
}
