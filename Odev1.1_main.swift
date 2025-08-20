
import Foundation


let adSoyad: String = "Mehmet Ali Sevdinoğlu"
let yas: Int = 24
let boy: Double = 170.0  
let yazilimciMi: Bool = true


var telefon: String? = "05525430031"
var linkedin: String? = "www.linkedin.com/in/mehmet-ali-sevdinoğlu-983179252"


print("Kişisel Bilgi Kartı")
print("--------------------")
print("Ad Soyad : \(adSoyad)")
print("Yaş      : \(yas)")
print("Boy      : \(boy)")
print("Yazılımcı: \(yazilimciMi)")


if let tel = telefon {
    print("Telefon  : \(tel)")
} else {
    print("Telefon  : Bilgi yok")
}

if let link = linkedin {
    print("LinkedIn : \(link)")
} else {
    print("LinkedIn : Bilgi yok")
}
