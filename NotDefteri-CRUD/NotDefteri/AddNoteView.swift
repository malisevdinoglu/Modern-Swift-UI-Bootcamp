//
//  AddNoteView.swift
//  NotDefteri
//
//  Created by Mehmet Ali Sevdinoğlu on 17.09.2025.
//
import SwiftUI
import CoreData

struct AddNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Örn: Alışveriş listesi", text: $title)
                        .textInputAutocapitalization(.sentences)
                }
                Section("İçerik") {
                    TextEditor(text: $content)
                        .frame(minHeight: 160)
                }
            }
            .navigationTitle("Yeni Not")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save)
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        note.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        note.date = Date()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Kaydetme hatası: \(error)")
        }
    }
}

#Preview {
    AddNoteView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
