import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        
        TabView (selection: $navigationManager.selectedTab){
            
            MapView()
                .tabItem {
                    Label("Harita", systemImage: "map.fill")
                }
                .tag(Tab.map)
             
            FavoritesListView()
                .tabItem {
                    Label("Favoriler", systemImage: "star.fill")
                }
                .tag(Tab.favorites)
        }
    }
}


struct MapView: View {

    @StateObject private var locationManager = LocationManager()
    @Query private var favoriteLocations: [FavoriteLocation]
    @Environment(\.modelContext) private var modelContext
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var newLocationName: String = ""
    @State private var showSaveAlert: Bool = false
    @State private var hasCenteredMap = false
    
    // YENİ: Canlı takip modunun açık olup olmadığını tutan state.
    @State private var isTrackingUser = false

    var body: some View {
        MapReader { proxy in
            Map(position: $cameraPosition) {
                if let location = locationManager.location {
                    Marker("Mevcut Konum", coordinate: location.coordinate)
                        .tint(.blue)
                }
                ForEach(favoriteLocations) { location in
                    Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .background(Circle().fill(.red))
                            .padding(4)
                    }
                }
            }
            .onTapGesture { position in
                // Haritaya dokunmak, serbest gezinme anlamına gelir, bu yüzden takibi kapatıyoruz.
                isTrackingUser = false
                if let coordinate = proxy.convert(position, from: .local) {
                    self.tappedCoordinate = coordinate
                    self.showSaveAlert = true
                }
            }
            .ignoresSafeArea()
        }
        .overlay(alignment: .bottomTrailing) { // Butonu haritanın sağ altına yerleştiriyoruz.
            // YENİ: Canlı Takip Butonu
            Button {
                // Butona basıldığında takip modunu aç/kapat.
                isTrackingUser.toggle()
                // Eğer takip modu YENİ AÇILDIYSA, haritayı hemen mevcut konuma ortala.
                if isTrackingUser, let location = locationManager.location {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        latitudinalMeters: 1000, // Takip için daha yakın bir görünüm
                        longitudinalMeters: 1000
                    ))
                }
            } label: {
                // Takip modunun durumuna göre butonun ikonu değişir.
                Image(systemName: isTrackingUser ? "location.fill" : "location")
                    .font(.title)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding()
        }
        .onChange(of: locationManager.location) { newLocation in
            // --- DEĞİŞEN KISIM BURASI ---
            // Sadece ilk açılışta VEYA canlı takip modu AÇIKSA haritayı güncelle.
            if let newLocation = newLocation {
                if !hasCenteredMap { // İlk açılışta bir kez ortala
                    cameraPosition = .region(MKCoordinateRegion(
                        center: newLocation.coordinate,
                        latitudinalMeters: 5000,
                        longitudinalMeters: 5000
                    ))
                    hasCenteredMap = true
                } else if isTrackingUser { // Takip modu açıksa SÜREKLİ ortala
                    cameraPosition = .region(MKCoordinateRegion(
                        center: newLocation.coordinate,
                        latitudinalMeters: 1000, // Takip için daha yakın görünüm
                        longitudinalMeters: 1000
                    ))
                }
            }
        }
        .alert("Favori Konum Ekle", isPresented: $showSaveAlert) {
            TextField("Konum Adı", text: $newLocationName)
            Button("Vazgeç", role: .cancel) { newLocationName = "" }
            Button("Kaydet") {
                addFavoriteLocation()
                newLocationName = ""
            }
        } message: {
            Text("Bu konuma bir isim vererek favorilerinize ekleyin.")
        }
    }

    private func addFavoriteLocation() {
        guard let coordinate = tappedCoordinate else { return }
        let newFavorite = FavoriteLocation(
            name: newLocationName.isEmpty ? "Favori Konum" : newLocationName,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            timestamp: .now
        )
        modelContext.insert(newFavorite)
    }
}


private extension MKCoordinateRegion {
    static let userRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530),
        latitudinalMeters: 10000,
        longitudinalMeters: 10000
    )
}


#Preview {
    ContentView()
        .modelContainer(for: FavoriteLocation.self, inMemory: true)
}
