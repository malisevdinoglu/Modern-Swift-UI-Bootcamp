# API Explorer (SwiftUI)

Bu proje, **Rick and Morty API** kullanarak gerçek verilerle bir **SwiftUI listeleme uygulaması** geliştirmek amacıyla yapılmıştır.  
Bootcamp ödevi kapsamındaki tüm gereksinimleri yerine getirmektedir.

---

## 🚀 Özellikler

- Gerçek REST API’den veri çekme (GET, sayfalama, arama parametreleri)
- Swift Concurrency (**async/await**) ile ağ istekleri
- **Codable** modellerle JSON parse
- SwiftUI ile:
  - Liste ekranı (scrollable + sayfalama)
  - Detay ekranı (büyük görsel, ek bilgiler)
  - Hata / boş durum ekranları
  - Yükleme göstergesi (ProgressView)
- **Pull-to-refresh**
- Favorilere ekleme / çıkarma (**UserDefaults** ile kalıcı saklama)
- **Resim önbellekleme** (NSCache + URLCache, `CachedAsyncImage`)
- Temiz **MVVM** mimarisi
- Testler:
  - Unit Test (Network + ViewModel, mock’lu JSON parse testleri)
  - UI Test (favoriye ekle → favoriler ekranında görüntüle)

---

##  Kurulum

1. Bu repo’yu klonlayın:
   ```bash
   git clone https://github.com/<kullanıcı-adın>/APIExplorer.git
   cd APIExplorer
   
   

## Mimari

Proje MVVM + Service yaklaşımıyla kurgulanmıştır:
    •    Model: Character, CharactersResponse, PageInfo
    •    ViewModel: CharacterListViewModel → sayfalama, arama, hata yönetimi
    •    View: CharacterListView, CharacterDetailView, FavoritesView
    •    Service: NetworkService, CharacterService → URLSession + async/await
    •    Persistence: FavoritesStore (UserDefaults)
    •    UI Utilities: CachedAsyncImage (NSCache ile görsel önbelleği)
    
## Testler
    •    Unit Testler
    •    Network katmanı mock’lanarak JSON parse testleri
    •    ViewModel durum testi (liste doluyor mu?)
    •    UI Testler
    •    Favori ekleme → Favoriler ekranında gözükme akışı
