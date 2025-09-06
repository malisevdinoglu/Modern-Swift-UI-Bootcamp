//
//  NewItemView.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import SwiftUI

struct NewItemView: View {
    @EnvironmentObject var vm: ListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var detail: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Örn: Alışveriş", text: $title)
                        .textInputAutocapitalization(.sentences)
                }
                Section("Açıklama") {
                    TextField("Kısa açıklama", text: $detail, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Yeni Öğeyi Ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        vm.addItem(title: title, detail: detail)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
