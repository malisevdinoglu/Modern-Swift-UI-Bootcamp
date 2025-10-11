//
//  HaritaUygulamaApp.swift
//  HaritaUygulama
//
//  Created by Mehmet Ali Sevdinoğlu on 10.10.2025.
//

import SwiftUI
import SwiftData

@main
struct HaritaUygulamamApp: App { // Proje adınızla eşleşmesi için 'HaritaUygulamaApp' -> 'HaritaUygulamamApp' olarak düzelttim.
    
    // Veritabanını Widget ile paylaşmak için özel bir ModelContainer oluşturuyoruz.
    // Bu, uygulama başladığında sadece bir kez oluşturulur.
    let sharedModelContainer: ModelContainer = {
        // Hangi veri modellerini (@Model) kullanacağımızı tanımlıyoruz.
        let schema = Schema([
            FavoriteLocation.self,
        ])
        
        // Veritabanının ayarlarını yapılandırıyoruz.
        // En önemli kısım: 'groupContainer'. Bu, verilerin App Group alanına kaydedilmesini sağlar.
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false, // Verilerin kalıcı olmasını sağlıyoruz.
            // DİKKAT: Buradaki App Group kimliğini kendinizinkiyle değiştirin!
            groupContainer: .identifier("group.com.Mali.HaritaUygulamam")
        )

        // Yapılandırmayı kullanarak asıl veritabanı container'ını oluşturuyoruz.
        // Bu işlem başarısız olursa uygulama çökerek sorunu hemen görmemizi sağlar.
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("ModelContainer oluşturulamadı: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Standart .modelContainer yerine, yukarıda oluşturduğumuz
        // özel ve paylaşılan container'ı kullanıyoruz.
        .modelContainer(sharedModelContainer)
    }
}
