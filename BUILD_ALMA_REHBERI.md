# 📦 Build Alma ve İndirme Rehberi

Bu rehber, GitHub Actions ile build alıp bilgisayarınıza indirmeniz için adım adım talimatlar içerir.

---

## ✅ Ön Hazırlık

### 1. GitHub Repository Kontrolü

- [ ] Projeniz GitHub'da bir repository'de olmalı
- [ ] `.github/workflows/build-and-upload.yml` dosyası mevcut olmalı
- [ ] `exportOptions.plist` dosyası proje kök dizininde olmalı

### 2. GitHub Secrets Ayarlama (Sadece İlk Kez)

**Repository → Settings → Secrets and variables → Actions** bölümüne gidin:

1. **TEAM_ID** secret'ını ekleyin:
   - Name: `TEAM_ID`
   - Value: `NJRDK44KQ5`
   - **Add secret** butonuna tıklayın

**Not:** Sadece build almak için `TEAM_ID` yeterli. Otomatik yükleme isterseniz `APPLE_ID` ve `APPLE_APP_SPECIFIC_PASSWORD` da eklemeniz gerekir.

---

## 🚀 Build Alma Adımları

### Adım 1: GitHub Repository'ye Git

1. Tarayıcınızda GitHub repository'nizi açın
2. **Actions** sekmesine tıklayın (üst menüde)

### Adım 2: Workflow'u Çalıştır

1. Sol tarafta **"Build and Archive iOS App"** workflow'unu göreceksiniz
2. Workflow'a tıklayın
3. Sağ üstte **"Run workflow"** butonuna tıklayın
4. Açılan pencerede:
   - **Branch:** `main` (veya hangi branch'teyseniz)
   - **Version:** (Opsiyonel) Versiyon numarası (örn: `1.0.7`)
   - **Build number:** (Opsiyonel) Build numarası (boş bırakırsanız otomatik artar)
5. **"Run workflow"** butonuna tıklayın

### Adım 3: Build İşlemini İzle

1. Workflow çalışmaya başlar
2. İşlem adımlarını görebilirsiniz:
   - ✅ Checkout code
   - ✅ Setup Xcode
   - ✅ Build and Archive
   - ✅ Export IPA
   - ✅ Upload IPA as artifact
3. **Toplam süre:** 10-20 dakika (ilk seferde daha uzun sürebilir)

### Adım 4: Build Tamamlandığında

1. Workflow tamamlandığında yeşil ✅ işareti görünür
2. Workflow'a tıklayın (detayları görmek için)

---

## 📥 Build'i İndirme

### Yöntem 1: GitHub Web Arayüzünden (Önerilen)

1. Workflow sayfasında sağ üstte **"Artifacts"** bölümünü bulun
2. **"ios-app-XXXX"** (XXXX = build numarası) linkine tıklayın
3. `.zip` dosyası indirilmeye başlar
4. İndirilen `.zip` dosyasını açın
5. İçinde `.ipa` dosyasını bulacaksınız

### Yöntem 2: GitHub CLI ile (Gelişmiş)

Eğer GitHub CLI kuruluysa:

```bash
gh run download <run-id> -n ios-app-*
```

---

## 📂 İndirilen Dosya

- **Dosya adı:** `ios-app-XXXX.zip` (XXXX = build numarası)
- **İçerik:** `VideoDownloader.ipa`
- **Boyut:** Genellikle 50-200 MB arası

---

## 🔍 Build Durumunu Kontrol Etme

### Başarılı Build

- ✅ Yeşil işaret görünür
- ✅ "Build Summary" adımında "✅ Build tamamlandı!" mesajı
- ✅ Artifacts bölümünde dosya görünür

### Başarısız Build

- ❌ Kırmızı işaret görünür
- ❌ Hangi adımda hata olduğunu görebilirsiniz
- ❌ Hata mesajını okuyup düzeltebilirsiniz

**Yaygın Hatalar:**

1. **Code signing error:**
   - `TEAM_ID` secret'ının doğru olduğundan emin olun
   - Apple Developer hesabınızın aktif olduğundan emin olun

2. **Scheme not found:**
   - Scheme adının "VideoDownloader" olduğundan emin olun
   - Xcode'da scheme'in paylaşıldığından emin olun

3. **Export failed:**
   - `exportOptions.plist` dosyasının doğru yerde olduğundan emin olun
   - `TEAM_ID`'nin doğru olduğundan emin olun

---

## 🎯 Hızlı Başlangıç (Özet)

1. **GitHub → Actions** sekmesine git
2. **"Build and Archive iOS App"** → **"Run workflow"**
3. **Branch seç** → **"Run workflow"**
4. **10-20 dakika bekle**
5. **Artifacts** bölümünden **`.zip` dosyasını indir**
6. **`.zip` dosyasını aç** → **`.ipa` dosyasını bul**

---

## 💡 İpuçları

### Build Numarasını Artırma

Her build'de build numarası otomatik olarak artar (GitHub run number). Manuel belirtmek isterseniz workflow çalıştırırken "Build number" alanına yazabilirsiniz.

### Versiyon Güncelleme

Workflow çalıştırırken "Version" alanına yeni versiyon numarasını yazabilirsiniz (örn: `1.0.7`). Boş bırakırsanız mevcut versiyon kullanılır.

### Build Geçmişi

Tüm build'lerinizi **Actions** sekmesinde görebilirsiniz. Her build'in durumunu, süresini ve artifact'larını görebilirsiniz.

### Build Silme

Eski build'leri silmek için:
1. Workflow'a tıklayın
2. Sağ üstte **"..."** menüsüne tıklayın
3. **"Delete workflow run"** seçin

---

## 🆘 Sorun Giderme

### Build Çalışmıyor

1. **Repository'de dosyalar var mı kontrol edin:**
   - `.github/workflows/build-and-upload.yml` mevcut mu?
   - `exportOptions.plist` mevcut mu?

2. **Secrets doğru mu kontrol edin:**
   - `TEAM_ID` = `NJRDK44KQ5`

3. **Workflow syntax hatası var mı kontrol edin:**
   - Actions sekmesinde kırmızı işaret görünüyor mu?

### IPA Dosyası Bulunamıyor

1. **Build başarılı mı kontrol edin:**
   - Yeşil ✅ işareti var mı?

2. **Artifacts bölümünü kontrol edin:**
   - Workflow sayfasında "Artifacts" bölümü görünüyor mu?

3. **Build loglarını kontrol edin:**
   - "Export IPA" adımında hata var mı?

---

## ✅ Kontrol Listesi

Build almadan önce:

- [ ] GitHub repository'de proje mevcut
- [ ] `.github/workflows/build-and-upload.yml` dosyası var
- [ ] `exportOptions.plist` dosyası var
- [ ] `TEAM_ID` secret'ı ayarlandı
- [ ] GitHub Actions erişimi var

Build aldıktan sonra:

- [ ] Build başarılı (yeşil ✅)
- [ ] Artifacts bölümünde dosya görünüyor
- [ ] `.zip` dosyası indirildi
- [ ] `.ipa` dosyası `.zip` içinde mevcut

---

## 📞 Yardım

Sorun yaşarsanız:

1. **Build loglarını kontrol edin:** Hangi adımda hata var?
2. **GitHub Actions dokümantasyonu:** [docs.github.com/actions](https://docs.github.com/actions)
3. **Workflow dosyasını kontrol edin:** Syntax hatası var mı?

**Başarılar! 🚀**

