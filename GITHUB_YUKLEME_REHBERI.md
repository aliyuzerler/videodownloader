# 🚀 GitHub'a Yükleme Rehberi

Bu rehber, projenizi GitHub'a yüklemeniz için adım adım talimatlar içerir.

---

## 📋 Ön Hazırlık

### 1. GitHub Hesabı
- [ ] GitHub hesabınız var mı? ([github.com](https://github.com) → Sign up)

### 2. Git Kurulumu
- [ ] Git kurulu mu? Kontrol edin: `git --version`
- [ ] Kurulu değilse: [git-scm.com/download/win](https://git-scm.com/download/win)

---

## 🔧 Adım Adım: GitHub'a Yükleme

### Adım 1: Git Repository Oluşturma

Proje klasörünüzde terminal açın ve şu komutları çalıştırın:

```bash
cd C:\Users\90553\Desktop\videodownloader
git init
```

### Adım 2: Dosyaları Ekleme

```bash
git add .
```

### Adım 3: İlk Commit

```bash
git commit -m "Initial commit: VideoDownloader iOS app with GitHub Actions workflow"
```

### Adım 4: GitHub'da Yeni Repository Oluşturma

1. [github.com](https://github.com) → Giriş yapın
2. Sağ üstte **"+"** → **"New repository"**
3. Bilgileri doldurun:
   - **Repository name:** `videodownloader` (veya istediğiniz isim)
   - **Description:** (Opsiyonel) "iOS Video Downloader App"
   - **Public** veya **Private** seçin
   - **⚠️ ÖNEMLİ:** "Initialize this repository with a README" işaretini **KALDIRIN**
4. **"Create repository"** butonuna tıklayın

### Adım 5: GitHub Repository URL'ini Kopyalama

Repository oluşturulduktan sonra GitHub size bir URL gösterecek:
- Örnek: `https://github.com/kullaniciadi/videodownloader.git`
- Bu URL'yi kopyalayın

### Adım 6: Remote Ekleme ve Push

Terminal'de şu komutları çalıştırın (URL'yi kendi repository URL'nizle değiştirin):

```bash
git remote add origin https://github.com/KULLANICIADI/REPOSITORY-ADI.git
git branch -M main
git push -u origin main
```

**Örnek:**
```bash
git remote add origin https://github.com/username/videodownloader.git
git branch -M main
git push -u origin main
```

### Adım 7: GitHub Kullanıcı Adı ve Şifre

Push yaparken GitHub kullanıcı adı ve şifre isteyecek:
- **Username:** GitHub kullanıcı adınız
- **Password:** GitHub şifreniz (veya Personal Access Token)

**⚠️ Not:** Eğer 2FA aktifse, şifre yerine **Personal Access Token** kullanmanız gerekir.

---

## 🔑 Personal Access Token Oluşturma (2FA için)

Eğer GitHub'da 2FA aktifse:

1. GitHub → **Settings** → **Developer settings**
2. **Personal access tokens** → **Tokens (classic)**
3. **Generate new token (classic)**
4. İsim verin (örn: "VideoDownloader")
5. **Expiration:** Süre seçin
6. **Scopes:** `repo` işaretleyin
7. **Generate token**
8. **Token'ı kopyalayın** (bir daha gösterilmez!)
9. Push yaparken şifre yerine bu token'ı kullanın

---

## ✅ Hızlı Komutlar (Özet)

```bash
# 1. Git repository oluştur
cd C:\Users\90553\Desktop\videodownloader
git init

# 2. Dosyaları ekle
git add .

# 3. Commit yap
git commit -m "Initial commit: VideoDownloader iOS app"

# 4. GitHub'da repository oluştur (web'den)
# https://github.com/new

# 5. Remote ekle (URL'yi kendi repository'nizle değiştirin)
git remote add origin https://github.com/KULLANICIADI/REPOSITORY-ADI.git

# 6. Branch'i main yap
git branch -M main

# 7. Push yap
git push -u origin main
```

---

## 🆘 Sorun Giderme

### "fatal: not a git repository"
- **Çözüm:** `git init` komutunu çalıştırın

### "remote origin already exists"
- **Çözüm:** 
  ```bash
  git remote remove origin
  git remote add origin https://github.com/KULLANICIADI/REPOSITORY-ADI.git
  ```

### "Authentication failed"
- **Çözüm:** 
  - Personal Access Token kullanın (2FA aktifse)
  - GitHub şifrenizin doğru olduğundan emin olun

### "Permission denied"
- **Çözüm:**
  - Repository'nin size ait olduğundan emin olun
  - Personal Access Token'ın `repo` yetkisi olduğundan emin olun

---

## 📝 Sonraki Adımlar

GitHub'a yükledikten sonra:

1. ✅ **GitHub Secrets ayarlayın:**
   - Repository → Settings → Secrets → Actions
   - `TEAM_ID` = `NJRDK44KQ5` ekleyin

2. ✅ **Build alın:**
   - Actions → "Build and Archive iOS App" → Run workflow
   - `BUILD_ALMA_REHBERI.md` dosyasına bakın

3. ✅ **Build'i indirin:**
   - Artifacts bölümünden `.ipa` dosyasını indirin

---

## 💡 İpuçları

### .gitignore Dosyası
- Büyük dosyaları (build, archive) yüklememek için `.gitignore` dosyası ekledim
- Bu dosya gereksiz dosyaların GitHub'a yüklenmesini engeller

### Commit Mesajları
- Her değişiklikte anlamlı commit mesajları yazın
- Örnek: "Update AdMob IDs", "Fix payment field error"

### Branch Kullanımı
- Ana branch: `main`
- Yeni özellikler için: `feature/yeni-ozellik`
- Hata düzeltmeleri için: `fix/hata-duzeltme`

---

**Başarılar! 🚀**

