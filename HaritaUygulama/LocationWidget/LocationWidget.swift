import WidgetKit
import SwiftUI
import SwiftData

// Widget'ın veriyi nasıl alacağını ve güncelleyeceğini tanımlayan "beyin".
struct Provider: TimelineProvider {
    
    // Widget ilk kez gösterilirken kullanılacak geçici veri.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), favoriteLocationName: "Favori Konum Adı")
    }

    // Widget galerisinde görünecek anlık bir görüntü için veri.
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Asenkron veri çekme işlemi için bir Task başlatıyoruz.
        Task {
            let entry = await fetchEntry()
            completion(entry)
        }
    }

    // Widget'ın ne zaman güncelleneceğini ve hangi veriyi göstereceğini belirleyen ana fonksiyon.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Asenkron veri çekme işlemi için bir Task başlatıyoruz.
        Task {
            let entry = await fetchEntry()
            
            // Widget'ın bir sonraki güncelleme zamanını belirliyoruz. 15 dakika sonra.
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            
            // Zaman çizelgesini oluşturuyoruz.
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }
    
    // SwiftData'dan en son favoriyi çeken, async ve MainActor üzerinde çalışan YENİ fonksiyon.
    @MainActor
    private func fetchEntry() -> SimpleEntry {
        // Ana uygulamadakiyle aynı App Group container'ını burada da oluşturuyoruz.
        guard let modelContainer = try? ModelContainer(for: FavoriteLocation.self, configurations: ModelConfiguration(groupContainer: .identifier("group.com.Mali.HaritaUygulamam"))) else {
            return SimpleEntry(date: .now, favoriteLocationName: "Veri Yok")
        }
        
        // Veritabanından en son ekleneni (tersten sıralayıp ilkini alarak) çekiyoruz.
        var descriptor = FetchDescriptor<FavoriteLocation>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        descriptor.fetchLimit = 1
        
        // mainContext'e @MainActor üzerinde olduğumuz için artık güvenle erişebiliriz.
        if let lastFavorite = try? modelContainer.mainContext.fetch(descriptor).first {
            return SimpleEntry(date: .now, favoriteLocationName: lastFavorite.name)
        } else {
            return SimpleEntry(date: .now, favoriteLocationName: "Favori Eklenmedi")
        }
    }
}

// Widget'ın bir "anı" için gereken veri.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let favoriteLocationName: String
}

// Widget'ın SwiftUI ile çizilen asıl arayüzü.
struct LocationWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Son Favori")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(entry.favoriteLocationName)
                    .font(.headline)
                    .lineLimit(2) // İsim çok uzunsa 2 satıra sığdır.
            }
        }
        .padding()
    }
}

// Widget'ı sisteme tanıtan ana yapı.
// @main'i buraya eklemek önemlidir.
struct LocationWidget: Widget {
    let kind: String = "LocationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LocationWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Son Favori Konum")
        .description("En son eklediğiniz favori konumu gösterir.")
        .supportedFamilies([.systemSmall]) // Sadece küçük boy widget'ı destekliyoruz.
    }
}

#Preview(as: .systemSmall) {
    LocationWidget()
} timeline: {
    SimpleEntry(date: .now, favoriteLocationName: "Özkan")
    SimpleEntry(date: .now, favoriteLocationName: "Okyanus Balık Evi")
}
