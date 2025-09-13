//
//  AddNoteView.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//
import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: NotesViewModel

    @State private var title: String = ""
    @State private var content: String = ""

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Örn: Alışveriş Listesi", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.next)
                }
                Section("İçerik") {
                    TextEditor(text: $content)
                        .frame(minHeight: 180)
                }
            }
            .navigationTitle("Yeni Not")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        vm.add(title: title, content: content)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
