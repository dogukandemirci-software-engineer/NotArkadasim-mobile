# Note Arkadaşım Proje Dökümantasyonu

Bu döküman, `note_arkadasim` projesinin kod tabanını, mimarisini, bağımlılıklarını ve temel işlevlerini anlamak için oluşturulmuştur.

## 1. Genel Bakış

**Note Arkadaşım**, öğrencilere yönelik tasarlanmış bir sosyal not ve haber paylaşım platformudur. Kullanıcılar kayıt olup giriş yapabilir, notlarını (PDF veya resim olarak) ve haberleri oluşturabilir, diğer kullanıcıların notlarını inceleyebilir ve profillerini yönetebilirler. Uygulama, modern bir Flutter mimarisi üzerine inşa edilmiştir ve zengin bir kullanıcı arayüzü sunar.

## 2. Bağımlılık Analizi (`pubspec.yaml`)

Proje, işlevselliğini zenginleştirmek için çeşitli Flutter paketlerinden yararlanır:

### UI & UX
- **`google_fonts`**: Metinler için özel fontlar kullanmayı sağlar.
- **`pinput`**: SMS veya e-posta ile gelen pin kodlarının girilmesi için şık bir arayüz sunar.
- **`introduction_screen`**: Yeni kullanıcılar için tanıtım ve onboarding ekranları oluşturur.
- **`glassmorphism`**: Arayüze "buzlu cam" efekti ekleyerek modern bir görünüm kazandırır.
- **`chips_choice`**: Hashtag seçimi gibi çoktan seçmeli işlemler için kullanılır.
- **`flutter_pdfview`**: Uygulama içinde PDF dosyalarını görüntülemeyi sağlar.

### Cihaz & Donanım Erişimi
- **`camera`**: Cihazın kamerasını kullanarak fotoğraf çekme işlevini yönetir.
- **`image_picker`**: Cihaz galerisinden resim seçmeyi sağlar.
- **`file_picker`**: Cihaz hafızasından dosya (özellikle PDF) seçmek için kullanılır.
- **`permission_handler`**: Kamera, depolama gibi cihaz izinlerini yönetir.
- **`path_provider`**: Uygulamanın dosya sistemindeki (geçici veya kalıcı) dizinlere erişimini sağlar.

### Ağ & Veri İşlemleri
- **`http` & `dio`**: Backend API'sine ağ istekleri (POST, GET vb.) göndermek için kullanılır. `auth_service` içerisinde SSL sertifika hatalarını ve yönlendirmeleri ele alan gelişmiş bir `http` kullanımı mevcuttur.
- **`shared_preferences`**: Kullanıcı oturum bilgileri (token, kullanıcı adı vb.) gibi basit verileri cihazda kalıcı olarak saklar.
- **`json_annotation`**: API'den gelen JSON verilerini Dart nesnelerine (modellere) dönüştürmek için kullanılır ve kod üretimini (code generation) destekler.

### Durum Yönetimi (State Management)
- **`provider`**: `PhotoProvider` gibi sınıflar aracılığıyla uygulama genelinde durumu yönetmek ve arayüzü güncellemek için kullanılır.

## 3. Proje Mimarisi ve Dosya Yapısı (`lib/`)

Proje, `lib` klasörü altında oldukça düzenli ve modüler bir yapıya sahiptir. Her klasör, belirli bir sorumluluğu üstlenir.

### 📂 `main.dart`
- Uygulamanın başlangıç noktasıdır.
- `WidgetsFlutterBinding.ensureInitialized()` ile Flutter motorunu başlatır.
- `GetInitialUpsertService`'i çağırarak uygulama açılışında üniversite ve bölüm listesi gibi başlangıç verilerini çeker.
- `ChangeNotifierProvider` ile `PhotoProvider`'ı widget ağacına ekler.
- `MaterialApp` widget'ını tanımlar, global temayı (`GoogleFonts` ile) ve uygulama rotalarını (`AppRoutes`) belirler.

### 📂 `routes/`
- **`routes.dart`**: Uygulama içindeki tüm sayfa rotalarını (named routes) statik sabitler olarak tanımlar. Bu, merkezi bir yerden rota yönetimi sağlar ve yazım hatalarını önler.

### 📂 `services/`
Uygulamanın iş mantığının ve dış dünya ile iletişiminin kalbidir.
- **`navigation_service.dart`**: `BuildContext`'e ihtiyaç duymadan uygulama içinde gezinmeyi sağlayan özel bir servis. Animasyonlu sayfa geçişleri (`PageRouteBuilder`) için de mantık içerir.
- **`user_service.dart`**: Kullanıcı verilerini yönetir. `shared_preferences` kullanarak kullanıcı modelini (token dahil) cihaza kaydeder, okur, siler (çıkış yapma) ve oturum durumunu kontrol eder.
- **`api_services/`**: Backend ile iletişimi yöneten tüm servisleri içerir.
    - **`baseapi/base_api.dart`**: API'nin temel IP adresini veya alan adını tutar.
    - **`auth_api/auth_service.dart`**: Kayıt (`register`) ve giriş (`login`) işlemlerini yönetir. `http` paketini kullanarak API'ye istek atar. Özellikle `login` fonksiyonu, sertifika hataları ve HTTP yönlendirmeleri (307 redirect) gibi gerçek dünya senaryolarını ele alacak şekilde gelişmiş bir mantığa sahiptir. Başarılı girişte `UserService` aracılığıyla kullanıcı bilgilerini kaydeder.
    - **`get_initial_api/get_initial_upsert_service.dart`**: Uygulama açılışında üniversite ve bölüm listesi gibi verileri çeker. Veriyi `dio` paketi ile API'den aldıktan sonra `shared_preferences` kullanarak **cache'ler**, böylece her açılışta tekrar ağ isteği yapmaz. Bu, performansı artıran önemli bir optimizasyondur.
    - **`note_api/note_api_service.dart`**: Notları getirmek için kullanılan **sahte (mock)** bir servistir. Gerçek bir API çağrısı yapmak yerine, `constants/fake_constants.dart` dosyasından veri okur ve sayfalama (pagination) mantığını simüle eder. Bu, backend tamamlanmadan frontend'in geliştirilmesine olanak tanır.
    - **`pin_check_api/pin_check_service.dart`**: E-posta doğrulama için kullanılan sahte bir PIN kontrol servisidir.

### 📂 `models/`
API'den gelen veya uygulama içinde kullanılan veri yapılarını tanımlar.
- `LoginModel`, `RegisterModel`, `UserModel`, `College`, `Department`, `Note`.
- **`meta.dart`, `result.dart`, `list_result.dart`, `paging_result.dart`**: API yanıtlarını sarmalamak için kullanılan çok güçlü ve standart bir yapı. Bu yapı, her API yanıtının bir `meta` nesnesi (başarı durumu, mesajlar, HTTP durum kodu) içermesini sağlar. `PagingResult`, sayfalama bilgilerini de (toplam sayfa, mevcut sayfa vb.) barındırır. Bu, API hatalarını ve verilerini UI katmanında tutarlı bir şekilde işlemeyi kolaylaştırır.

### 📂 `pages/`
Uygulamanın kullanıcı arayüzü ekranlarını içerir.
- **`auth/`**: `login`, `register`, `email` (pin doğrulama), `change_password`, `accept_license` gibi tüm kimlik doğrulama ekranlarını barındırır. Bu sayfalar, `AuthService`'i kullanarak iş mantığını tetikler.
- **`home/`**:
    - **`home_page.dart`**: Oturum açıldıktan sonraki ana iskelet sayfadır. `NA_bottom_navigationbar` kullanarak uygulamanın ana bölümleri (`HomePageContent`, `NotesPage`, `NewsPage` vb.) arasında geçişi sağlar.
    - **`home_page_content.dart`**: Karşılama ekranıdır. `UserService`'den kullanıcı adını alır ve bazı hızlı istatistikler gösterir.
- **`notes/`**:
    - **`notes_page.dart`**: Notların listelendiği ana ekrandır. `NoteApiService`'den gelen verileri kullanarak "sonsuz kaydırma" (infinite scroll) ile notları yükler. Arama ve hashtag filtreleme gibi gelişmiş UI özelliklerine sahiptir.
    - **`note_view/note_view_page.dart`**: Tek bir notun detaylarını, özellikle de PDF'ini gösterir. `flutter_pdfview` paketini kullanarak PDF'i bir URL'den indirip geçici bir dosyaya kaydederek görüntüler.
- **`add_note/` & `add_news/`**: Yeni not ve haber eklemek için kullanılan form sayfalarıdır. Dosya seçimi, hashtag seçimi gibi component'leri kullanır.
- **`profile_menu/`**: Kullanıcı profili ve ayarlar menülerini içerir. `ExpansionTile` ile iç içe geçmiş bir menü yapısı sunar. `personal_information_page.dart` sayfası, `UserService`'den aldığı mevcut verilerle formu doldurarak kullanıcı bilgilerini güncellemeyi sağlar.
- **`on_board/`**: `introduction_screen` paketini kullanarak uygulama ilk açıldığında kullanıcıya gösterilen tanıtım ekranlarını içerir.

### 📂 `components/`
Uygulama genelinde tekrar tekrar kullanılan, markalaşmış (branded) UI bileşenleridir. `NA_` öneki (Note Arkadaşım) ile isimlendirilmişlerdir.
- **`NA_button`**: Yüklenme durumunu (`isLoading`) destekleyen, gradient arkaplanlı standart bir butondur.
- **`NA_classic_appbar`**: Gradient arkaplanlı standart bir `AppBar`.
- **`NA_popup`**: Başarı, hata ve uyarı durumları için özelleştirilmiş, animasyonlu bir popup bileşeni.
- **`NA_multi_select_hashtag`**: Hashtag arama ve seçme işlevselliği sunan, kendi state'ini yöneten karmaşık bir bileşen.
- **`NA_password_text_field`**: Şifre görünürlüğünü değiştirmeyi sağlayan ikonlu bir metin giriş alanıdır.
- `Diğerleri`: `NA_dropdown`, `NA_text_field` gibi diğer bileşenler de uygulamanın genel tema ve stil bütünlüğünü sağlar.

### 📂 `themes/`
- **`theme.dart`**: Uygulamanın renk paletini (`primaryColor`, `errorColor` vb.), yazı tipi ailesini (`Euclid Circular`) ve `ThemeData` nesnesini merkezi olarak tanımlar. Bu sayede tüm component'ler aynı stil kurallarını takip eder.

### 📂 `validation/`
Form doğrulaması için standart ve yeniden kullanılabilir bir mantık katmanıdır.
- **`validation_rules.dart`**: E-posta, şifre, kullanıcı adı gibi alanlar için `regex` kurallarını ve karakter uzunluklarını tanımlar.
- **`validator.dart`**: Belirli bir alan türü (`FieldType`) için bu kuralları uygulayan ana doğrulama sınıfıdır.
- **`validate_*.dart` dosyaları**: `TextFormField`'ların `validator` özelliğinde kolayca kullanılabilmek için `Validator` sınıfını sarmalayan yardımcı fonksiyonlardır.

## 4. Temel İş Akışları (Chain of Thought Örneği)

### Kullanıcı Kayıt (Register) Akışı:
1.  **UI (`RegisterPage`)**: Kullanıcı ad, soyad, e-posta, şifre gibi bilgileri girer ve üniversite/bölüm seçer. "Kayıt Ol" `NA_Button`'una tıklar.
2.  **Form Validation**: `_formKey.currentState!.validate()` çağrılır. `validation/` klasöründeki kurallar (örn: `validateEmail`, `validatePassword`) çalışır. Hata varsa kullanıcıya gösterilir.
3.  **Service Call (`_handleRegister`)**: Form geçerliyse, `ApiService.instance.register()` fonksiyonu çağrılır.
4.  **Model (`RegisterModel`)**: UI'daki `TextEditingController`'lardan ve seçilen dropdown değerlerinden alınan verilerle bir `RegisterModel` nesnesi oluşturulur.
5.  **API (`AuthService.register`)**: `RegisterModel`, JSON'a çevrilir ve `http.post` ile backend'deki `/auth/register` endpoint'ine gönderilir.
6.  **Response Handling**: API'den gelen yanıta göre (`RegisterResponse`), `RegisterPage`'de ya bir başarı mesajı (`showSnackBar`) gösterilip `/login` sayfasına yönlendirme yapılır ya da bir hata popup'ı (`buildNAPopup`) gösterilir.

### Notları Görüntüleme (Infinite Scroll) Akışı:
1.  **UI (`NotesPage`)**: Sayfa ilk açıldığında `initState` içinde `_loadNotes()` fonksiyonu tetiklenir.
2.  **Service Call (`_loadNotes`)**: `NoteApiService.instance.getNotesByPage()` çağrılır. `_isLoadingMore` `true` yapılır.
3.  **API (`NoteApiService`)**: Bu servis (şu an için sahte veriyle çalışıyor) bir sonraki sayfanın notlarını (`List<Note>`) döndürür. Servis, hangi sayfada kaldığını kendi içinde (`lastPageCount`) takip eder.
4.  **State Update**: Dönen yeni notlar, `_notes` listesine eklenir (`_notes.addAll(newNotes)`). Eğer dönen liste boşsa, `_hasMoreNotes` `false` yapılır ve daha fazla not yüklenmeye çalışılmaz. `_isLoadingMore` `false` yapılır.
5.  **UI Update**: `setState` çağrıldığı için `GridView.builder`, `_filteredNotes` listesindeki yeni verilerle güncellenir.
6.  **Scrolling**: Kullanıcı sayfanın sonuna yaklaştığında (`_scrollController` listener'ı), `_isLoadingMore` ve `_hasMoreNotes` kontrol edilerek `_loadNotes()` tekrar tetiklenir ve döngü yeniden başlar.

## 5. Sonuç

**Note Arkadaşım**, Flutter'ın en iyi pratiklerini (best practices) takip eden, iyi yapılandırılmış ve ölçeklenebilir bir projedir. Özellikle şu noktalar dikkat çekicidir:
- **Modülerlik**: Sorumlulukların `services`, `models`, `pages`, `components` gibi ayrı katmanlara bölünmesi.
- **Merkezi Yönetim**: Rota (`routes`), tema (`themes`) ve navigasyon (`navigation_service`) gibi konuların merkezi servisler veya sınıflar tarafından yönetilmesi.
- **Sağlam API Mimarisi**: API yanıtları için standartlaştırılmış `Result` modelleri ve `GetInitialUpsertService`'teki gibi caching stratejileri.
- **Yeniden Kullanılabilirlik**: `NA_` önekli component'ler sayesinde UI tutarlılığı ve geliştirme hızı.
- **Gelişmiş Hata Yönetimi**: `AuthService`'teki yönlendirme ve SSL hatası yönetimi gibi detaylı hata kontrolü.
- **Aşamalı Geliştirme**: `NoteApiService` gibi sahte servisler kullanılarak backend'den bağımsız frontend geliştirme yeteneği.
