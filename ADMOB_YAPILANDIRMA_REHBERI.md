# AdMob Yapılandırma Rehberi

Bu rehber, uygulamanızdaki AdMob bilgilerini değiştirmeniz için gerekli adımları içerir.

## 📍 Değiştirilmesi Gereken Dosyalar

### 1. **Info.plist** - AdMob Uygulama Kimliği (App ID)
**Dosya Yolu:** `VideoDownloader/Info.plist`

**Değiştirilecek Satır:** 17-18
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-9814860409600590~9886455305</string>
```

**Yeni Değer:** Yeni AdMob App ID'nizi buraya yazın (format: `ca-app-pub-XXXXXXXX~XXXXXXXX`)

**Açıklama:** Bu, AdMob hesabınızın ana uygulama kimliğidir. Tüm reklam birimleri bu ID'ye bağlıdır.

---

### 2. **AdMobInterstitialManager.swift** - Geçiş Reklamı (Tam Ekran Reklam) ID
**Dosya Yolu:** `VideoDownloader/helpers/AdMobInterstitialManager.swift`

**Değiştirilecek Satır:** 16
```swift
private var adUnitID: String = "ca-app-pub-9814860409600590/9770978614"
```

**Yeni Değer:** Yeni Geçiş Reklamı (Interstitial) Ad Unit ID'nizi buraya yazın (format: `ca-app-pub-XXXXXXXX/XXXXXXXX`)

**Açıklama:** Geçiş reklamı (Interstitial), uygulama içinde ekranlar arası geçişlerde gösterilen tam ekran reklamlardır. Kullanıcı bir ekrandan diğerine geçerken gösterilir.

---

### 3. **BannerView.swift** - Banner Reklamı (Alt Reklam) ID
**Dosya Yolu:** `VideoDownloader/helpers/BannerView.swift`

**Değiştirilecek Satır:** 36
```swift
bannerView.adUnitID = "ca-app-pub-9814860409600590/3397141956"
```

**Yeni Değer:** Yeni Banner Reklamı Ad Unit ID'nizi buraya yazın (format: `ca-app-pub-XXXXXXXX/XXXXXXXX`)

**Açıklama:** Banner reklamı, ekranın alt kısmında sürekli görünen yatay reklamlardır. Kullanıcı içerik görüntülerken ekranın altında kalır.

---

### 4. **AppOpenAdManagerDelegate.swift** - Uygulama Açılış Reklamı ID
**Dosya Yolu:** `VideoDownloader/helpers/AppOpenAdManagerDelegate.swift`

**Değiştirilecek Satır:** 58
```swift
appOpenAd = try await AppOpenAd.load(
    with: "ca-app-pub-9814860409600590/7099856890", request: Request())
```

**Yeni Değer:** Yeni Uygulama Açılış Reklamı (App Open) Ad Unit ID'nizi buraya yazın (format: `ca-app-pub-XXXXXXXX/XXXXXXXX`)

**Açıklama:** Uygulama açılış reklamı, kullanıcı uygulamayı açtığında veya arka plandan geri döndüğünde gösterilen tam ekran reklamlardır.

---

## 🔧 Adım Adım Yapılacaklar

1. **AdMob Konsolundan Yeni ID'leri Alın:**
   - [AdMob Konsol](https://apps.admob.com/) adresine giriş yapın
   - Uygulamanızı seçin veya yeni bir uygulama oluşturun
   - **Uygulama Kimliği (App ID)**'yi kopyalayın
   - Her reklam tipi için Ad Unit ID'leri oluşturun:
     - **Banner Reklamı** (Alt reklam)
     - **Geçiş Reklamı** (Interstitial - Tam ekran reklam)
     - **Uygulama Açılış Reklamı** (App Open)
   - Her birinin ID'sini kopyalayın

2. **Yukarıdaki 4 dosyada değişiklikleri yapın:**
   - Her dosyada ilgili ID'yi yeni ID ile değiştirin
   - Formatların doğru olduğundan emin olun

3. **Projeyi temizleyin ve yeniden derleyin:**
   - Xcode'da: `Product > Clean Build Folder` (Shift + Cmd + K)
   - Sonra: `Product > Build` (Cmd + B)

4. **Test Edin:**
   - Test cihazında uygulamayı çalıştırın
   - Her reklam tipinin göründüğünden emin olun:
     - Banner reklamı ekranın altında görünmeli
     - Geçiş reklamı ekranlar arası geçişlerde gösterilmeli
     - Uygulama açılış reklamı uygulama açılırken gösterilmeli

---

## ⚠️ Önemli Notlar

- **App ID formatı:** `ca-app-pub-XXXXXXXX~XXXXXXXX` (tire işareti `~` ile ayrılır)
- **Ad Unit ID formatı:** `ca-app-pub-XXXXXXXX/XXXXXXXX` (slash `/` ile ayrılır)
- Tüm ID'lerin doğru formatta olduğundan emin olun
- Değişikliklerden sonra mutlaka uygulamayı test edin
- Production'a yüklemeden önce test reklamları ile kontrol edin
- Her reklam tipi için ayrı Ad Unit ID oluşturmanız gerekir

---

## 📝 Reklam Tipleri ve Mevcut ID'ler (Referans)

### Uygulama Kimliği (App ID)
- **ID:** `ca-app-pub-9814860409600590~9886455305`
- **Kullanım:** Info.plist dosyasında

### Geçiş Reklamı (Interstitial - Tam Ekran Reklam)
- **ID:** `ca-app-pub-9814860409600590/9770978614`
- **Kullanım:** AdMobInterstitialManager.swift dosyasında
- **Ne zaman gösterilir:** Ekranlar arası geçişlerde

### Banner Reklamı (Alt Reklam)
- **ID:** `ca-app-pub-9814860409600590/3397141956`
- **Kullanım:** BannerView.swift dosyasında
- **Ne zaman gösterilir:** Ekranın alt kısmında sürekli

### Uygulama Açılış Reklamı (App Open)
- **ID:** `ca-app-pub-9814860409600590/7099856890`
- **Kullanım:** AppOpenAdManagerDelegate.swift dosyasında
- **Ne zaman gösterilir:** Uygulama açılırken veya arka plandan dönerken

---

## 💡 Reklam Tipleri Hakkında

### Banner Reklamı
- Ekranın alt kısmında görünen yatay reklam
- Kullanıcı içerik görüntülerken ekranda kalır
- En az rahatsız edici reklam tipi

### Geçiş Reklamı (Interstitial)
- Tam ekran reklam
- Ekranlar arası geçişlerde gösterilir
- Daha yüksek gelir potansiyeli

### Uygulama Açılış Reklamı
- Uygulama açılırken gösterilen tam ekran reklam
- Kullanıcı uygulamayı açtığında veya arka plandan döndüğünde gösterilir
- Yüksek görünürlük oranı

