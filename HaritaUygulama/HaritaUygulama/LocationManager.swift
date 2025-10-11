import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var address: String = "Adres bilgisi bekleniyor..."

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }

    func requestLocationPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }

    // --- DEĞİŞİKLİK BURADA BAŞLIYOR ---

    // Konum güncellemeleri geldiğinde tetiklenen ana fonksiyon.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.location = newLocation
        
       
        Task {
            await fetchAddress(for: newLocation)
        }
    }

   
    private func fetchAddress(for location: CLLocation) async {
        do {
            // 'try await' ile geocoder'ın işini bitirmesini bekliyoruz.
            // İşlem bitene kadar bu satırda bekler, kod bloke olmaz.
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            // Eğer bir sonuç dönerse, adresi formatla.
            if let placemark = placemarks.first {
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                
                let formattedAddress = "\(streetName) \(streetNumber), \(postalCode) \(city), \(administrativeArea)"
                
                // ÖNEMLİ: @Published değişkenleri gibi UI güncellemeleri
                // her zaman ana iş parçacığında (Main Thread) yapılmalıdır.
                // MainActor.run, içindeki kodun ana iş parçacığında çalışmasını garanti eder.
                await MainActor.run {
                    self.address = formattedAddress
                }
            }
        } catch {
            // Eğer 'try await' bir hata fırlatırsa, catch bloğu çalışır.
            print("Adres alınırken hata oluştu: \(error.localizedDescription)")
            await MainActor.run {
                self.address = "Adres bulunamadı."
            }
        }
    }
    
    // --- DEĞİŞİKLİK BURADA BİTİYOR ---

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Lokasyon alınırken hata oluştu: \(error.localizedDescription)")
    }
}
