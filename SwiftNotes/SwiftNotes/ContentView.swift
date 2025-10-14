import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    
    @State private var showingAddNoteView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.content)
                            .font(.subheadline)
                            .lineLimit(2) // İçeriğin en fazla 2 satırı görünsün
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notlarım")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddNoteView = true
                    }) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNoteView) {
                AddNoteView()
            }
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
