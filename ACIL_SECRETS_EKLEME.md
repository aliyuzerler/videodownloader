# 🔴 ACİL: GitHub Secrets Ekleme (IPA Export İçin ZORUNLU)

## ❌ Sorun

IPA export **başarısız** çünkü GitHub Secrets'a **Apple ID eklenmemiş**.

Hata: `error: exportArchive No Accounts`

## ✅ ÇÖZÜM: GitHub Secrets Ekleme (5 Dakika)

### ⚠️ ÖNEMLİ: Bu adımı yapmadan IPA export ÇALIŞMAYACAK!

---

## 📋 Adım Adım: GitHub Secrets Ekleme

### 1️⃣ GitHub'a Gidin

1. Tarayıcınızda açın: **`https://github.com/aliyuzerler/videodownloader`**
2. Üst menüden **Settings** sekmesine tıklayın

### 2️⃣ Secrets Bölümüne Gidin

1. Sol menüden **Secrets and variables** → **Actions** seçin
2. **New repository secret** (yeşil buton) tıklayın

### 3️⃣ APPLE_ID Ekleyin

**Name (İsim):**
```
APPLE_ID
```
(Büyük harfle, alt çizgi ile)

**Secret (Değer):**
```
[App-specific password'ü aldığınız Apple ID e-posta adresi]
```
Örnek: `ali.yuzerler@example.com` veya hangi e-posta ile giriş yaptıysanız

**Add secret** butonuna tıklayın

### 4️⃣ APPLE_APP_SPECIFIC_PASSWORD Ekleyin

1. Tekrar **New repository secret** butonuna tıklayın

**Name (İsim):**
```
APPLE_APP_SPECIFIC_PASSWORD
```
(Büyük harfle, alt çizgi ile)

**Secret (Değer):**
```
uwpw-slrs-mgqv-bket
```
(Tire işaretleri ile birlikte, tam olarak bu şekilde)

**Add secret** butonuna tıklayın

### 5️⃣ TEAM_ID Kontrolü

1. Secrets listesinde **TEAM_ID** var mı kontrol edin
2. **Varsa:** ✅ Güncellemeye gerek yok
3. **Yoksa:** 
   - **New repository secret** → **Name:** `TEAM_ID`, **Secret:** `NJRDK44KQ5`
   - **Add secret**

---

## ✅ Kontrol Listesi

Secret'ları ekledikten sonra şunları kontrol edin:

- [ ] **APPLE_ID** → Apple ID e-posta adresiniz (örn: `ali.yuzerler@example.com`)
- [ ] **APPLE_APP_SPECIFIC_PASSWORD** → `uwpw-slrs-mgqv-bket` (tire işaretleri ile)
- [ ] **TEAM_ID** → `NJRDK44KQ5`

**Toplam 3 secret olmalı!**

---

## ⚠️ ÖNEMLİ NOTLAR

### Secret İsimleri (Büyük/Küçük Harf)

**DOĞRU:**
- ✅ `APPLE_ID`
- ✅ `APPLE_APP_SPECIFIC_PASSWORD`
- ✅ `TEAM_ID`

**YANLIŞ:**
- ❌ `apple_id` (küçük harf)
- ❌ `Apple_ID` (karışık)
- ❌ `APPLE-ID` (tire işareti)

### Apple ID

- App-specific password'ü **hangi Apple ID ile aldıysanız**, o Apple ID'yi kullanın
- E-posta adresi tam olarak yazılmalı (örn: `ali.yuzerler@example.com`)

### Password Format

- Tire işaretleri ile birlikte: `uwpw-slrs-mgqv-bket`
- Boşluk olmamalı
- Tam olarak bu şekilde yazılmalı

---

## 🚀 Build'i Tekrar Çalıştırın

Secret'ları ekledikten sonra:

1. **Actions** sekmesine gidin
2. **Build and Archive iOS App** workflow'unu seçin
3. **Run workflow** → **Run workflow** butonuna tıklayın
4. Bu sefer **IPA dosyası başarıyla oluşturulacak!** 🎉

---

## 🆘 Hala Çalışmıyorsa

### Kontrol Edilecekler:

1. **Secret isimleri doğru mu?**
   - Büyük harfle mi? (`APPLE_ID`, `APPLE_APP_SPECIFIC_PASSWORD`)
   - Alt çizgi ile mi? (tire değil)

2. **3 secret var mı?**
   - `APPLE_ID`
   - `APPLE_APP_SPECIFIC_PASSWORD`
   - `TEAM_ID`

3. **Apple ID doğru mu?**
   - App-specific password'ü aldığınız Apple ID ile aynı mı?

4. **Password formatı doğru mu?**
   - Tire işaretleri ile: `uwpw-slrs-mgqv-bket`
   - Boşluk yok mu?

5. **Build'i yeniden çalıştırdınız mı?**
   - Secret'ları ekledikten sonra build'i tekrar çalıştırmanız gerekiyor

---

## 📸 Görsel Rehber

### Adım 1: Settings
```
Repository → [Settings] (üst menü)
```

### Adım 2: Secrets
```
Sol menü → Secrets and variables → Actions
```

### Adım 3: New Secret
```
[New repository secret] (yeşil buton)
```

### Adım 4: Secret Ekleme
```
Name: APPLE_ID
Secret: your-email@example.com
[Add secret]
```

---

## 🎯 Özet

**Yapmanız gereken:**
1. ✅ GitHub → Settings → Secrets and variables → Actions
2. ✅ `APPLE_ID` ekleyin (Apple ID e-posta adresiniz)
3. ✅ `APPLE_APP_SPECIFIC_PASSWORD` ekleyin (`uwpw-slrs-mgqv-bket`)
4. ✅ `TEAM_ID` kontrol edin (`NJRDK44KQ5`)
5. ✅ Build'i tekrar çalıştırın

**Toplam süre:** 5 dakika
**Sonuç:** IPA dosyası oluşturulacak! 🚀

---

**🔴 ÖNEMLİ:** GitHub Secrets'a Apple ID eklemeden IPA export çalışmayacak! Lütfen yukarıdaki adımları takip edin.

