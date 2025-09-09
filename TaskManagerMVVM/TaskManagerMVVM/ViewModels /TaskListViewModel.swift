//
//  TaskListViewModel.swift
//  TaskManagerMVVM
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import Foundation

/// ViewModel katmanı: İş kuralları + durum yönetimi.
/// - Görev ekleme, silme, tamamlama değişikliği burada.
/// - @Published ile UI otomatik güncellenir.
final class TaskListViewModel: ObservableObject {
    // Filtre (Tümü / Aktif / Tamamlandı)
    enum Filter: String, CaseIterable, Identifiable {
        case all = "Tümü"
        case active = "Aktif"
        case completed = "Tamamlandı"
        
        var id: Self { self }
    }
    
    @Published var tasks: [TaskItem] = []
    @Published var filter: Filter = .all
    
    // Basit kalıcı saklama (UserDefaults + JSON)
    private let storageKey = "TaskManagerMVVM.tasks"
    
    init() {
        load()
    }
    
    // MARK: - API
    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.insert(TaskItem(title: trimmed), at: 0) // en üste ekle
        save()
    }
    
    func toggleCompletion(for task: TaskItem) {
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[idx].isCompleted.toggle()
            save()
        }
    }
    
    /// Tümü görünümünde (filtre yokken) gelen index’lere göre siler.
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        save()
    }
    
    /// Filtreli listede güvenli silme (ID ile).
    func deleteTasks(withIDs ids: Set<UUID>) {
        tasks.removeAll { ids.contains($0.id) }
        save()
    }
    
    // Filtre uygulanmış liste (View bu listeyi gösterir)
    var filteredTasks: [TaskItem] {
        switch filter {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }
    
    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([TaskItem].self, from: data) else { return }
        tasks = saved
    }
}
