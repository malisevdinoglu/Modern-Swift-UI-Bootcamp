import Foundation



func hesapMakinesi(_ a: Double, _ b: Double, islem: String) -> Double? {
    switch islem {
    case "+": return a + b
    case "-": return a - b
    case "*": return a * b
    case "/":
        guard b != 0 else { return nil }
        return a / b
    default:
        return nil
    }
}


func yazdir(_ aciklama: String, _ sonuc: Double?) {
    if let deger = sonuc {
        print("\(aciklama): \(deger)")
    } else {
        print("\(aciklama): hesaplanamadı")
    }
}


func filtreVeSirala(_ dizi: [Int], esik: Int) -> [Int] {
    
    let filtre = dizi.filter { $0 > esik }
   
    let sirali = filtre.sorted { $0 < $1 }
    return sirali
}


@main
struct Runner {
    static func main() {
      
        yazdir("Toplama",  hesapMakinesi(10, 5, islem: "+"))
        yazdir("Çıkarma",  hesapMakinesi(10, 5, islem: "-"))
        yazdir("Çarpma",   hesapMakinesi(10, 5, islem: "*"))
        yazdir("Bölme",    hesapMakinesi(10, 5, islem: "/"))
        yazdir("Sıfıra bölme", hesapMakinesi(10, 0, islem: "/"))

       
        let sayilar = [3, 10, 7, 25, 4, 18, 2]
        let sonuc = filtreVeSirala(sayilar, esik: 5)

        print("Orijinal:", sayilar)
        print("Filtre+Sıralı (5’ten büyük):", sonuc)
    }
}

