//
//  NoteDetail.swift
//  NotDefteri
//
//  Created by Mehmet Ali Sevdinoğlu on 17.09.2025.
//

import SwiftUI
import CoreData

struct NoteDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var note: Note
    @State private var localTitle: String = ""
    @State private var localContent: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Başlık", text: $localTitle)
                        .textInputAutocapitalization(.sentences)
                }
                Section("İçerik") {
                    TextEditor(text: $localContent)
                        .frame(minHeight: 180)
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                        Text(note.wrappedDate, style: .date)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Not Detayı")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") { save() }
                        .disabled(localTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                // Form alanlarını mevcut değerlerle doldur
                localTitle = note.title ?? ""
                localContent = note.content ?? ""
            }
        }
    }

    private func save() {
        note.title = localTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        note.content = localContent.trimmingCharacters(in: .whitespacesAndNewlines)
        // Tarihi güncelleyebilirsin (opsiyonel): note.date = Date()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Güncelleme hatası: \(error)")
        }
    }
}

#Preview {
    // Preview için sahte context
    let ctx = PersistenceController.shared.container.viewContext
    let sample = Note(context: ctx)
    sample.id = UUID()
    sample.title = "Örnek Başlık"
    sample.content = "Örnek içerik"
    sample.date = Date()
    return NoteDetailView(note: sample)
        .environment(\.managedObjectContext, ctx)
}
