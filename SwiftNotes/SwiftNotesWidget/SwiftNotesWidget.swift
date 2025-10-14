import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    // Kendi App Group ID'niz olduğundan emin olun
    let appGroupID = "group.com.mali.SwiftNotes"

    // Xcode'un istediği placeholder fonksiyonu
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), latestNoteTitle: "Not Başlığı", latestNoteContent: "Notunuzun içeriği burada görünecek...")
    }

    // Xcode'un istediği 'getSnapshot' fonksiyonu (eski stil)
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let note = await fetchLatestNote()
            let entry = SimpleEntry(
                date: Date(),
                latestNoteTitle: note?.title ?? "Başlık Yok",
                latestNoteContent: note?.content ?? "Herhangi bir not bulunamadı."
            )
            completion(entry)
        }
    }

    // Xcode'un istediği 'getTimeline' fonksiyonu (eski stil)
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            let note = await fetchLatestNote()
            let entry = SimpleEntry(
                date: Date(),
                latestNoteTitle: note?.title ?? "Başlık Yok",
                latestNoteContent: note?.content ?? "Herhangi bir not bulunamadı."
            )

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: .now)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    @MainActor
    private func fetchLatestNote() async -> Note? {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!.appendingPathComponent("SwiftNotes.sqlite")
        let schema = Schema([Note.self])
        let config = ModelConfiguration(schema: schema, url: containerURL)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(container)
            let fetchDescriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            let notes = try context.fetch(fetchDescriptor)
            return notes.first
        } catch {
            print("Widget için veri çekilemedi: \(error.localizedDescription)")
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let latestNoteTitle: String
    let latestNoteContent: String
}

struct SwiftNotesWidgetEntryView : View {
    var entry: Provider.Entry
    
    // Uygulamayı açacak bir URL tanımlayalım
    private var appURL: URL {
        URL(string: "swiftnotes://app")!
    }

    var body: some View {
        // Tıklama özelliğini eklemek için VStack'i Link ile sarmalıyoruz
        Link(destination: appURL) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.latestNoteTitle)
                    .font(.headline)
                Text(entry.latestNoteContent)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Spacer()
            }
            .padding()
        }
    }
}

struct SwiftNotesWidget: Widget {
    let kind: String = "SwiftNotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SwiftNotesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Son Notum")
        .description("En son eklediğiniz notu gösterir.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
