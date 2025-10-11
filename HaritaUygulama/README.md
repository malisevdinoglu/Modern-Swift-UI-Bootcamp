Lokasyon Servisleriyle Haritalı Uygulama Geliştirme
Bu proje, iOS için modern Swift teknolojileri kullanılarak geliştirilmiş, konum tabanlı özelliklere sahip kapsamlı bir harita uygulamasıdır. Kullanıcıların mevcut konumlarını görmelerine, favori yerlerini kaydetmelerine ve bu verilerle iOS ekosistemi (Siri, Widget'lar) üzerinden etkileşime girmelerine olanak tanır.

Not: Yukarıdaki görsel yerine kendi ekran görüntünüzü ekleyebilirsiniz.

                            ✨ ÖZELLİKLER
Temel Fonksiyonellik

Konum İzni: Uygulama, kullanıcıdan konumuna erişmek için standart iOS iznini ister.

Canlı Konum Takibi: Kullanıcının mevcut konumu harita üzerinde anlık olarak mavi bir işaretçi ile gösterilir.

Ters Geokodlama (Reverse Geocoding): Kullanıcının anlık koordinatları, okunabilir bir adrese çevrilerek ekranda gösterilir.

İnteraktif Harita: Kullanıcılar harita üzerinde gezinebilir, yakınlaştırma ve uzaklaştırma yapabilir.

Favori Ekleme: Haritada herhangi bir noktaya dokunarak o konuma özel bir isim verip favorilere kaydetme.

Kalıcı Veri Saklama: SwiftData kullanılarak eklenen favori konumlar, uygulama kapatılıp açılsa bile kaybolmaz.

Favori Listesi: Ayrı bir sekmede, eklenen tüm favori konumların listelenmesi.

Favori Silme: Listelenen favorileri sola kaydırarak kolayca silebilme.

İleri Seviye Özellikler

📍 Canlı Takip Modu (Live Tracking): Sağ alttaki buton ile haritanın kullanıcıyı sürekli merkezde tuttuğu bir takip modu aktive edilebilir.

🗣️ Siri & Spotlight Entegrasyonu (App Intents):

"HaritaUygulamam içinde haritayı aç" diyerek uygulamayı harita sekmesinde başlatma.

"HaritaUygulamam içinde favorilerimi aç" diyerek uygulamayı favoriler listesinde başlatma.

📱 Ana Ekran Widget'ı (WidgetKit): Ana ekrana eklenebilen, en son kaydedilen favori konumu gösteren bir widget.

⚡ Modern Concurrency: Arka plan işlemleri (adres çevirme vb.), async/await kullanılarak modern ve verimli bir şekilde yönetilir.

Not: Yukarıdaki görsel yerine kendi widget ekran görüntünüzü ekleyebilirsiniz.

                          🛠️ KULLANILAN TEKNOLOJİLER
UI Framework: SwiftUI

Harita: MapKit

Konum Servisleri: CoreLocation

Veri Kalıcılığı: SwiftData

Siri/Kestirmeler: App Intents

Ana Ekran Widget'ı: WidgetKit

Asenkron İşlemler: Swift Concurrency (async/await)

Durum Yönetimi: Combine (@Published, ObservableObject)

                                    🚀 KURULUM
Bu projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

Projeyi klonlayın veya indirin.

HaritaUygulamam.xcodeproj dosyasını Xcode ile açın.

ÖNEMLİ: App Group Yapılandırması
Widget ve ana uygulamanın veri paylaşabilmesi için kendi benzersiz App Group kimliğinizi oluşturmanız gerekmektedir.

Proje ayarlarında Signing & Capabilities sekmesine gidin.

Hem HaritaUygulamam hedefi hem de LocationWidgetExtension hedefi için + Capability diyerek App Groups ekleyin.

group.com.sirketadiniz.projeadiniz formatında yeni bir grup oluşturun ve her iki hedef için de bu grubu seçin.

Oluşturduğunuz bu kimliği aşağıdaki iki dosyada ilgili yerlere yazın:

HaritaUygulamamApp.swift -> ModelConfiguration içinde

LocationWidget.swift -> fetchEntry() fonksiyonu içinde

Kod İmzalama (Code Signing):

Proje ayarlarında Signing & Capabilities sekmesi altında, hem ana uygulama hem de widget hedefi için kendi geliştirici takımınızı (Team) seçin.

Fiziksel bir iOS cihazı Mac'inize bağlayın.

Xcode'da hedef olarak cihazınızı seçin ve Çalıştır (►) butonuna basın.

                               📂 PROJE MİMARİSİ 
HaritaUygulamamApp.swift: Uygulamanın ana başlangıç noktası. Paylaşılan SwiftData container'ını yapılandırır.

ContentView.swift: Ana TabView yapısını barındırır ve sekmeler arası geçişi yönetir.

MapView.swift: Tüm interaktif harita mantığını ve arayüzünü içeren ana ekran.

FavoritesListView.swift: Kaydedilen favori konumları listeleyen ve silme işlemini yöneten ekran.

LocationManager.swift: CoreLocation ile ilgili tüm işlemleri (konum alma, adres çevirme) yöneten sınıf.

FavoriteLocation.swift: SwiftData için veri modelini tanımlayan sınıf.

NavigationManager.swift: App Intents'in doğru sekmeyi açabilmesi için uygulama içi navigasyonu yöneten singleton sınıf.

AppShortcuts.swift: Siri ve Spotlight komutlarını tanımlayan AppIntent yapıları.

LocationWidget/: Widget'ın mantığını (Provider), arayüzünü (LocationWidgetEntryView) ve sisteme tanıtılmasını (LocationWidget, LocationWidgetBundle) içeren tüm dosyalar.
