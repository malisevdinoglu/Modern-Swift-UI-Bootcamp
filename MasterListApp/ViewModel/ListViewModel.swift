//
//  ListViewModel.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import Foundation

final class ListViewModel: ObservableObject {
    @Published var items: [TodoItem]

    init() {
        self.items = [
            TodoItem(title: "SwiftUI öğren", detail: "State ve View yaşam döngüsü"),
            TodoItem(title: "MVVM’i kavra", detail: "ObservableObject & @Published"),
            TodoItem(title: "Git pratik", detail: "push, pull, branch, PR"),
            TodoItem(title: "UI/UX notları", detail: "Buton stilleri, boşluk, kontrast"),
            TodoItem(title: "Staj defteri", detail: "Günlük akış ve ekran görüntüleri"),
            TodoItem(title: "Renk psikolojisi", detail: "Sektörlere göre dağılım"),
            TodoItem(title: "Erasmus site", detail: "Etkinlik ekranı ve filtreler"),
            TodoItem(title: "Section kullan", detail: "List + Section pratik"),
            TodoItem(title: "Detay ekranı", detail: "SF Symbol ile zengin"),
            TodoItem(title: "Tema dene", detail: "onAppear ile rastgele tint")
        ]
    }

    var pendingItems: [TodoItem] { items.filter { !$0.isDone } }
    var doneItems:    [TodoItem] { items.filter {  $0.isDone } }

    func addItem(title: String, detail: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        items.insert(TodoItem(title: title, detail: detail), at: 0)
    }

    func deletePending(at offsets: IndexSet) {
        let ids = offsets.map { pendingItems[$0].id }
        items.removeAll { ids.contains($0.id) }
    }

    func deleteDone(at offsets: IndexSet) {
        let ids = offsets.map { doneItems[$0].id }
        items.removeAll { ids.contains($0.id) }
    }

    func delete(_ item: TodoItem) { items.removeAll { $0.id == item.id } }

    func toggle(_ item: TodoItem) {
        if let i = items.firstIndex(where: { $0.id == item.id }) {
            items[i].isDone.toggle()
        }
    }
}
