# App Store Abonelik - Payment Field Hatası Çözüm Rehberi

## 🔍 Hata Açıklaması

"Payment field" hatası, App Store Connect'te abonelik yapılandırması ile ilgili bir sorundur. Bu hata genellikle şu durumlarda ortaya çıkar:

1. Ürün ID yanlış veya App Store Connect'te yapılandırılmamış
2. Abonelik grubu oluşturulmamış veya yanlış yapılandırılmış
3. Abonelik durumu "Ready to Submit" değil
4. StoreKit yapılandırma dosyası eksik veya hatalı

---

## ✅ Çözüm Adımları

### 1. App Store Connect'te Ürün Yapılandırması

#### A. Abonelik Grubu Oluşturma
1. [App Store Connect](https://appstoreconnect.apple.com/) → Uygulamanızı seçin
2. **Features** → **In-App Purchases** → **Subscription Groups**
3. Yeni bir abonelik grubu oluşturun (örn: "Premium Subscription")
4. Grubu kaydedin

#### B. Abonelik Ürünü Oluşturma
1. **In-App Purchases** → **+** butonuna tıklayın
2. **Auto-Renewable Subscription** seçin
3. Ürün bilgilerini doldurun:
   - **Reference Name:** Remove Ads Subscription
   - **Product ID:** `remove_ads_new` (kodunuzdaki ID ile tam eşleşmeli)
   - **Subscription Group:** Oluşturduğunuz grubu seçin
   - **Subscription Duration:** Monthly (veya istediğiniz süre)
   - **Price:** Fiyatı belirleyin

#### C. Abonelik Detaylarını Doldurma
1. **Subscription Information** bölümünde:
   - **Display Name:** Kullanıcıya görünecek isim
   - **Description:** Abonelik açıklaması
   - **Review Information:** Apple incelemesi için gerekli bilgiler

2. **Localizations** bölümünde:
   - Türkçe ve İngilizce çevirileri ekleyin

#### D. Durum Kontrolü
- Abonelik durumunun **"Ready to Submit"** olduğundan emin olun
- Eğer "Missing Metadata" hatası varsa, eksik bilgileri tamamlayın

---

### 2. StoreKit Yapılandırma Dosyası (Opsiyonel ama Önerilen)

Test için StoreKit yapılandırma dosyası oluşturun:

1. Xcode'da: **File** → **New** → **File**
2. **StoreKit Configuration File** seçin
3. Dosyayı projenize ekleyin
4. Ürün ID'nizi ekleyin: `remove_ads_new`
5. Test için fiyat ve süre bilgilerini girin

**Kullanım:**
- Test için: Xcode'da **Product** → **Scheme** → **Edit Scheme** → **Run** → **Options** → StoreKit Configuration dosyanızı seçin
- Production için: Bu dosyayı kullanmayın, gerçek App Store bağlantısını kullanın

---

### 3. Kod Kontrolleri

#### A. Product ID Kontrolü
**Dosya:** `VideoDownloader/app/Constants.swift`

```swift
static var WEEKLY_SUBID = "remove_ads_new"
```

Bu ID'nin App Store Connect'teki Product ID ile **tam olarak eşleştiğinden** emin olun.

#### B. Hata Mesajları
Artık uygulamanızda detaylı hata mesajları gösterilecek. Hata oluştuğunda:
- Konsol loglarını kontrol edin
- Kullanıcıya gösterilen hata mesajını okuyun
- Hata mesajı size hangi adımda sorun olduğunu söyleyecek

---

### 4. Test Adımları

#### A. Sandbox Test Hesabı
1. App Store Connect → **Users and Access** → **Sandbox Testers**
2. Test kullanıcısı oluşturun
3. Cihazınızda: **Settings** → **App Store** → Sandbox hesabı ile giriş yapın

#### B. Test Senaryoları
1. Uygulamayı çalıştırın
2. Premium ekranına gidin
3. "Satın Al" butonuna tıklayın
4. Sandbox hesabı ile ödeme yapmayı deneyin

#### C. Hata Kontrolü
- Konsol loglarını izleyin
- Hata mesajlarını kontrol edin
- Xcode console'da şu mesajları arayın:
  - `⚠️ Geçersiz Ürün ID'leri:` → Ürün ID yanlış
  - `❌ Ürün isteği başarısız:` → Ağ veya yapılandırma sorunu
  - `❌ Satın alma başarısız:` → Ödeme işlemi hatası

---

## 🔧 Yaygın Hatalar ve Çözümleri

### Hata 1: "Ürün bulunamadı"
**Sebep:** Product ID yanlış veya App Store Connect'te yapılandırılmamış
**Çözüm:**
- App Store Connect'te Product ID'nin tam olarak `remove_ads_new` olduğundan emin olun
- Büyük/küçük harf duyarlılığına dikkat edin
- Abonelik durumunun "Ready to Submit" olduğunu kontrol edin

### Hata 2: "Ödeme alanı hatası"
**Sebep:** Abonelik grubu eksik veya yanlış yapılandırılmış
**Çözüm:**
- Abonelik grubunun oluşturulduğundan emin olun
- Ürünün bu gruba atandığını kontrol edin
- Abonelik süresinin belirlendiğinden emin olun

### Hata 3: "Ürün mevcut değil"
**Sebep:** Abonelik henüz onaylanmamış veya durumu yanlış
**Çözüm:**
- App Store Connect'te aboneliğin durumunu kontrol edin
- "Missing Metadata" uyarılarını giderin
- Durumun "Ready to Submit" olduğundan emin olun

### Hata 4: "Ağ bağlantı hatası"
**Sebep:** İnternet bağlantısı veya App Store servisleri
**Çözüm:**
- İnternet bağlantınızı kontrol edin
- Birkaç dakika bekleyip tekrar deneyin
- VPN kullanıyorsanız kapatın

---

## 📋 Kontrol Listesi

Uygulamanızı App Store'a yüklemeden önce:

- [ ] App Store Connect'te abonelik grubu oluşturuldu
- [ ] Ürün ID (`remove_ads_new`) App Store Connect'te yapılandırıldı
- [ ] Abonelik durumu "Ready to Submit"
- [ ] Tüm metadata (isim, açıklama, fiyat) dolduruldu
- [ ] Sandbox test hesabı ile test edildi
- [ ] Konsol loglarında hata yok
- [ ] Uygulama içinde hata mesajları düzgün görünüyor

---

## 🆘 Ek Yardım

Eğer sorun devam ederse:

1. **Xcode Console Loglarını** kontrol edin - detaylı hata mesajları artık Türkçe ve anlaşılır
2. **App Store Connect** → **In-App Purchases** → Ürününüzün detay sayfasını kontrol edin
3. **Apple Developer Forums** veya **Apple Developer Support** ile iletişime geçin

---

## 📝 Notlar

- Aboneliklerin App Store'da görünmesi 24-48 saat sürebilir
- Test için Sandbox hesabı kullanın, production hesabı ile test yapmayın
- StoreKit Configuration dosyası sadece test içindir, production'da kullanılmaz
- Ürün ID'leri değiştirilemez, yanlışsa yeni bir ürün oluşturmanız gerekir

