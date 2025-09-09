//
//  TaskListView.swift
//  TaskManagerMVVM
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

/// Ana ekran: Liste, ekleme alanı, filtre ve silme.
struct TaskListView: View {
    @EnvironmentObject var viewModel: TaskListViewModel
    @State private var newTitle: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                // Ekleme alanı
                HStack(spacing: 8) {
                    TextField("Yeni görev girin…", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit(add)
                    
                    Button {
                        add()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Görev ekle")
                }
                
                // Filtre (Tümü/Aktif/Tamamlandı)
                Picker("Filtre", selection: $viewModel.filter) {
                    ForEach(TaskListViewModel.Filter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                
                // Liste
                List {
                    ForEach(viewModel.filteredTasks) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(for: task)
                        }
                    }
                    // Kaydırarak Silme (.onDelete)
                    .onDelete(perform: delete)
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Görevler")
        }
    }
    
    // MARK: - Actions
    private func add() {
        viewModel.addTask(title: newTitle)
        newTitle = ""
    }
    
    private func delete(_ offsets: IndexSet) {
        // Filtre "Tümü" ise indeksler ana diziyi temsil eder.
        if viewModel.filter == .all {
            viewModel.deleteTasks(at: offsets)
        } else {
            // Filtreli görünümde doğru öğeleri silmek için ID eşleştir.
            let ids = Set(offsets.map { viewModel.filteredTasks[$0].id })
            viewModel.deleteTasks(withIDs: ids)
        }
    }
}
