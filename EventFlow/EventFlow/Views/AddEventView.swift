//
//  AddEventView.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: EventStore

    @State private var title = ""
    @State private var date = Date()
    @State private var type: EventType = .diger
    @State private var hasReminder = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Etkinlik") {
                    TextField("Etkinlik adı", text: $title)
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                    Picker("Tür", selection: $type) {
                        ForEach(EventType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    Toggle("Hatırlatıcı", isOn: $hasReminder)
                }
            }
            .navigationTitle("Yeni Etkinlik")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Etkinlik adı boş olamaz", isPresented: $showAlert) {
                Button("Tamam", role: .cancel) {}
            }
        }
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { showAlert = true; return }
        store.add(title: trimmed, date: date, type: type, hasReminder: hasReminder)
        dismiss()
    }
}

#Preview {
    AddEventView().environmentObject(EventStore())
}
