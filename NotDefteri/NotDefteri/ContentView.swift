import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Core Data'dan her zaman "en yeni üstte" çekeriz; ekranda isteğe göre yeniden sıralayacağız.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.date, ascending: false)],
        animation: .default
    )
    private var notes: FetchedResults<Note>

    @State private var showingAdd = false
    @State private var searchText = ""
    @State private var newestFirst = true  // sıralama tercihi

    // Arama + sıralama uygulanmış görünüm verisi
    private var displayedNotes: [Note] {
        var items = notes.map { $0 }

        // Arama: başlıkta arar (case-insensitive)
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let q = searchText.lowercased()
            items = items.filter { ($0.title ?? "").lowercased().contains(q) }
        }

        // Sıralama: en yeni / en eski
        items.sort { a, b in
            let da = a.date ?? .distantPast
            let db = b.date ?? .distantPast
            return newestFirst ? (da > db) : (da < db)
        }
        return items
    }

    var body: some View {
        NavigationStack {
            Group {
                if displayedNotes.isEmpty {
                    // Empty state
                    ContentUnavailableView(
                        "Henüz not yok",
                        systemImage: "note.text",
                        description: Text(searchText.isEmpty
                                          ? "Sağ üstten + ile yeni bir not ekleyebilirsin."
                                          : "Aramana uygun sonuç bulunamadı.")
                    )
                    .padding(.horizontal)
                } else {
                    List {
                        ForEach(displayedNotes, id: \.objectID) { note in
                            NavigationLink {
                                NoteDetailView(note: note)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.wrappedTitle)
                                        .font(.headline)
                                    Text(note.wrappedDate, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteNotesFromDisplayed)
                    }
                }
            }
            .navigationTitle("Notlarım")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sırala", selection: $newestFirst) {
                            Text("En Yeni Üstte").tag(true)
                            Text("En Eski Üstte").tag(false)
                        }
                    } label: {
                        Label("Sırala", systemImage: "arrow.up.arrow.down")
                    }
                    .accessibilityLabel("Sıralama")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni Not")
                }
            }
            .sheet(isPresented: $showingAdd) { AddNoteView() }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Başlığa göre ara")
        }
    }

    // Filtrelenmiş/sıralanmış listeden silerken doğru Core Data nesnelerini bulup siler
    private func deleteNotesFromDisplayed(offsets: IndexSet) {
        withAnimation {
            let toDelete = offsets.map { displayedNotes[$0] }
            toDelete.forEach(viewContext.delete)
            do { try viewContext.save() } catch { print("Silme hatası: \(error)") }
        }
    }
}

extension Note {
    var wrappedTitle: String { (self.value(forKey: "title") as? String) ?? "Başlıksız" }
    var wrappedDate: Date  { (self.value(forKey: "date")  as? Date)  ?? Date() }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
