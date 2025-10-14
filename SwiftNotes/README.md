# SwiftNotes: Not Tutma Uygulaması ve Widget Projesi

Bu proje, SwiftUI, SwiftData ve WidgetKit teknolojileri kullanılarak geliştirilmiş bir iOS not tutma uygulamasıdır. Kullanıcıların not eklemesine, silmesine ve notlarını ana ekranlarında bir widget aracılığıyla görmesine olanak tanır.

## Kullanılan Teknolojiler

Bu proje, modern iOS geliştirme pratiklerini sergilemek amacıyla aşağıdaki teknolojiler üzerine kurulmuştur:

-   **SwiftUI:** Uygulamanın ve widget'ın tüm kullanıcı arayüzleri deklaratif ve modern bir yaklaşımla SwiftUI kullanılarak oluşturulmuştur.
-   **SwiftData:** Notların kalıcı olarak saklanması ve yönetilmesi için Apple'ın yeni ve güçlü SwiftData çatısı kullanılmıştır.
-   **WidgetKit:** Ana uygulamadaki en son notu kullanıcının ana ekranında göstermek için bir widget (Widget Extension) geliştirilmiştir.
-   **App Groups:** Ana uygulama ile widget'ın aynı SwiftData veritabanını güvenli bir şekilde paylaşabilmesi için App Groups yeteneği (capability) kullanılmıştır.
-   **URL Schemes:** Widget'a tıklandığında ana uygulamanın açılmasını sağlayan etkileşim özelliği, özel URL şemaları kullanılarak gerçekleştirilmiştir.

## Proje Yapısı ve Açıklaması

Proje, ana uygulama ve widget uzantısı olmak üzere iki ana hedeften (target) oluşur.

### Ana Uygulama (`SwiftNotes`)

-   **`Note.swift`**: SwiftData için `@Model` makrosu ile tanımlanmış, not verilerini (başlık, içerik, oluşturulma tarihi) temsil eden veri modelidir.
-   **`ContentView.swift`**: Kayıtlı notları bir liste halinde gösteren ve yeni not ekleme ekranına yönlendiren ana ekrandır. Not silme işlevi de bu ekranda yer alır.
-   **`AddNoteView.swift`**: Kullanıcının yeni bir not için başlık ve içerik girmesini sağlayan ve bu notu SwiftData'ya kaydeden ekrandır.

### Widget Uzantısı (`SwiftNotesWidget`)

-   **`SwiftNotesWidget.swift`**: Widget'ın tüm mantığını ve görünümünü içeren ana dosyadır. İçerisinde aşağıdaki temel yapılar bulunur:

    1.  **Provider (`Provider`)**: WidgetKit'e widget'ın ne zaman ve hangi veriyle güncelleneceğini söyleyen yapıdır.
        -   `placeholder(in:)`: Widget ilk kez gösterildiğinde veya yüklenirken geçici bir sahte veri sunar.
        -   `getSnapshot(in:completion:)`: Widget galerisinde gösterilecek tek bir anlık görüntüyü sağlar.
        -   `getTimeline(in:completion:)` : Widget'ın gelecekteki güncellemelerini ve o anlarda hangi veriyi (`SimpleEntry`) göstereceğini belirleyen bir zaman çizelgesi oluşturur. Bu projede, en son notu çeker ve 15 dakika sonra yeniden güncellenmesini planlar.

    2.  **TimelineEntry (`SimpleEntry`)**: Belirli bir zaman diliminde widget'ın göstermesi gereken tüm verileri (bizim durumumuzda not başlığı ve içeriği) içeren basit bir modeldir.

    3.  **Entry View (`SwiftNotesWidgetEntryView`)**: Widget'ın gerçek SwiftUI görünümüdür. `Provider`'dan aldığı `SimpleEntry` verisini kullanarak kullanıcı arayüzünü çizer.

## Etkileşimli Özellik Nasıl Çalışır?

Widget'ın etkileşimli olması, yani tıklandığında ana uygulamayı açması, iki temel adımdan oluşur:

1.  **`Link` ve `URL`:** Widget'ın SwiftUI görünümü (`SwiftNotesWidgetEntryView`), bir `Link` yapısı ile sarmalanmıştır. Bu `Link`, hedef olarak `swiftnotes://app` gibi özel bir URL'e ayarlanmıştır.
2.  **URL Schemes:** Ana uygulamanın proje ayarlarında (`Info > URL Types`), `swiftnotes` şeması tanımlanmıştır. Bu sayede iOS, bu şema ile başlayan bir URL'e tıklandığında `SwiftNotes` uygulamasını açması gerektiğini bilir.

Bu iki adım, WidgetKit ve iOS'in temel özelliklerini kullanarak widget ile uygulama arasında basit ama güçlü bir etkileşim sağlar.

## Projeyi Çalıştırma

1.  Projeyi Xcode ile açın.
2.  Proje ayarlarında (`Signing & Capabilities`), hem `SwiftNotes` hem de `SwiftNotesWidgetExtension` hedefleri için **App Groups** özelliğini etkinleştirin ve her ikisi için de aynı, benzersiz bir grup ID'si belirleyin. Bu projede kullanılan ID **`group.com.mali.SwiftNotes`** olarak ayarlanmıştır.
3.  `SwiftNotesWidget.swift` dosyasındaki `appGroupID` değişkeninin, bir önceki adımda belirlenen ID ile aynı olduğundan emin olun.
4.  Önce `SwiftNotes` şemasını seçip çalıştırarak birkaç not ekleyin.
5.  Ardından `SwiftNotesWidgetExtension` şemasını seçip çalıştırarak widget'ı ana ekranınıza ekleyin.
