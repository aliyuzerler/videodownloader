# ⚠️ GitHub Secrets Eksik!

## ❌ Sorun

IPA export başarısız çünkü **GitHub Secrets'a Apple ID eklenmemiş**.

Hata mesajı:
```
error: exportArchive No Accounts
error: exportArchive No signing certificate "iOS Development" found
```

## ✅ Çözüm: GitHub Secrets Ekleme

### 🔴 ÖNEMLİ: Bu adımı yapmadan IPA export çalışmayacak!

### Adım 1: GitHub'a Gidin

1. Tarayıcınızda: `https://github.com/aliyuzerler/videodownloader`
2. **Settings** sekmesine tıklayın (üst menüde)

### Adım 2: Secrets Bölümüne Gidin

1. Sol menüden **Secrets and variables** → **Actions** seçin
2. **New repository secret** butonuna tıklayın

### Adım 3: APPLE_ID Ekleyin

```
Name: APPLE_ID
Secret: [App-specific password'ü aldığınız Apple ID e-posta adresi]
```

- **Add secret** butonuna tıklayın

### Adım 4: APPLE_APP_SPECIFIC_PASSWORD Ekleyin

1. **New repository secret** butonuna tekrar tıklayın
2. Şu bilgileri girin:

```
Name: APPLE_APP_SPECIFIC_PASSWORD
Secret: uwpw-slrs-mgqv-bket
```

- **Add secret** butonuna tıklayın

### Adım 5: TEAM_ID Kontrolü

- Secrets listesinde `TEAM_ID` var mı kontrol edin
- Varsa: ✅ Güncellemeye gerek yok
- Yoksa: Ekleyin → `Name: TEAM_ID`, `Secret: NJRDK44KQ5`

## ✅ Kontrol Listesi

Secret'ları ekledikten sonra şunları kontrol edin:

- [ ] `APPLE_ID` → Apple ID e-posta adresiniz
- [ ] `APPLE_APP_SPECIFIC_PASSWORD` → `uwpw-slrs-mgqv-bket`
- [ ] `TEAM_ID` → `NJRDK44KQ5`

## 🚀 Build'i Tekrar Çalıştırın

Secret'ları ekledikten sonra:

1. **Actions** sekmesine gidin
2. **Build and Archive iOS App** workflow'unu seçin
3. **Run workflow** → **Run workflow**
4. Bu sefer **IPA dosyası başarıyla oluşturulacak!** 🎉

## ⚠️ Önemli Notlar

1. **Secret isimleri büyük harfle olmalı:**
   - ✅ `APPLE_ID`
   - ✅ `APPLE_APP_SPECIFIC_PASSWORD`
   - ❌ `apple_id` (yanlış)
   - ❌ `Apple_ID` (yanlış)

2. **Apple ID:** App-specific password'ü aldığınız Apple ID'yi kullanın

3. **Password Format:** Tire işaretleri ile birlikte: `uwpw-slrs-mgqv-bket`

## 🆘 Hala Çalışmıyorsa

### Kontrol Edilecekler:

1. **Secret isimleri doğru mu?**
   - Büyük harfle, alt çizgi ile: `APPLE_ID`, `APPLE_APP_SPECIFIC_PASSWORD`

2. **Apple ID doğru mu?**
   - App-specific password'ü aldığınız Apple ID ile aynı mı?

3. **Secret'lar görünüyor mu?**
   - Settings → Secrets and variables → Actions
   - 3 secret görünüyor mu?

4. **Build'i yeniden çalıştırdınız mı?**
   - Secret'ları ekledikten sonra build'i tekrar çalıştırmanız gerekiyor

---

**ÖNEMLİ:** GitHub Secrets'a Apple ID eklemeden IPA export çalışmayacak! Lütfen yukarıdaki adımları takip edin. 🔴

