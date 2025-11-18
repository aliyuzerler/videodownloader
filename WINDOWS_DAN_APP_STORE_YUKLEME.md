# Windows'tan App Store'a Uygulama Yükleme Rehberi

## ✅ Evet, Windows'tan Yükleyebilirsiniz!

GitHub Actions kullanarak otomatik build alıp, Windows'tan App Store Connect'e yükleyebilirsiniz. Bu yöntem macOS'a ihtiyaç duymaz!

---

## 🚀 Yöntem 1: GitHub Actions ile Otomatik Build + Windows'tan Yükleme

### Avantajlar:
- ✅ macOS'a ihtiyaç yok
- ✅ Otomatik build işlemi
- ✅ Windows'tan yükleme yapabilirsiniz
- ✅ Ücretsiz (GitHub Actions ücretsiz planı yeterli)

### Adım 1: GitHub Actions Workflow Dosyası Oluşturma

Projenizin kök dizininde `.github/workflows/` klasörü oluşturun ve `build-and-upload.yml` dosyası ekleyin:

```yaml
name: Build and Archive iOS App

on:
  workflow_dispatch:  # Manuel tetikleme
  push:
    branches:
      - main
    tags:
      - 'v*'  # v1.0.0 gibi tag'ler için

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: latest-stable
    
    - name: Select Xcode version
      run: sudo xcode-select -s /Applications/Xcode.app
    
    - name: Show Xcode version
      run: xcodebuild -version
    
    - name: Install dependencies (if using CocoaPods)
      run: |
        if [ -f "Podfile" ]; then
          pod install
        fi
    
    - name: Build and Archive
      env:
        APPLE_ID: ${{ secrets.APPLE_ID }}
        APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}
        TEAM_ID: ${{ secrets.TEAM_ID }}
      run: |
        # Versiyon ve build numarasını güncelle (opsiyonel)
        # plutil -replace CFBundleShortVersionString -string "1.0.7" VideoDownloader/Info.plist
        # plutil -replace CFBundleVersion -string "${{ github.run_number }}" VideoDownloader/Info.plist
        
        # Archive oluştur
        xcodebuild clean archive \
          -workspace VideoDownloader.xcworkspace \
          -scheme VideoDownloader \
          -configuration Release \
          -archivePath ./build/VideoDownloader.xcarchive \
          -allowProvisioningUpdates \
          CODE_SIGN_IDENTITY="Apple Distribution" \
          DEVELOPMENT_TEAM="${{ secrets.TEAM_ID }}"
    
    - name: Export IPA
      run: |
        xcodebuild -exportArchive \
          -archivePath ./build/VideoDownloader.xcarchive \
          -exportOptionsPlist ./exportOptions.plist \
          -exportPath ./build
    
    - name: Upload IPA as artifact
      uses: actions/upload-artifact@v4
      with:
        name: ios-app
        path: build/*.ipa
        retention-days: 7
    
    - name: Upload to App Store Connect (Optional)
      if: github.event_name == 'workflow_dispatch'
      env:
        APPLE_ID: ${{ secrets.APPLE_ID }}
        APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}
      run: |
        xcrun altool --upload-app \
          --type ios \
          --file ./build/*.ipa \
          --username "$APPLE_ID" \
          --password "$APPLE_APP_SPECIFIC_PASSWORD"
```

### Adım 2: Export Options Dosyası Oluşturma

Proje kök dizininde `exportOptions.plist` dosyası oluşturun:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>NJRDK44KQ5</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

### Adım 3: GitHub Secrets Ayarlama

GitHub repository'nizde **Settings** → **Secrets and variables** → **Actions** bölümüne gidin ve şu secret'ları ekleyin:

1. **APPLE_ID:** Apple Developer hesabınızın e-posta adresi
2. **APPLE_APP_SPECIFIC_PASSWORD:** App-specific password (aşağıda nasıl oluşturulacağı açıklanmış)
3. **TEAM_ID:** `NJRDK44KQ5` (Development Team ID'niz)

#### App-Specific Password Oluşturma:

1. [appleid.apple.com](https://appleid.apple.com/) → Giriş yapın
2. **Sign-In and Security** → **App-Specific Passwords**
3. **Generate an app-specific password**
4. İsim verin (örn: "GitHub Actions")
5. Oluşturulan şifreyi kopyalayın (bir daha gösterilmez!)
6. GitHub Secrets'a `APPLE_APP_SPECIFIC_PASSWORD` olarak ekleyin

### Adım 4: Workflow'u Çalıştırma

1. GitHub repository'nize gidin
2. **Actions** sekmesine tıklayın
3. **Build and Archive iOS App** workflow'unu seçin
4. **Run workflow** butonuna tıklayın
5. Branch seçin ve **Run workflow** butonuna tıklayın
6. Build işlemi başlar (10-20 dakika sürebilir)

### Adım 5: Build'i İndirme

1. Workflow tamamlandığında **Actions** sekmesinde görünür
2. Workflow'a tıklayın
3. **Artifacts** bölümünde **ios-app** linkine tıklayın
4. `.ipa` dosyasını indirin

---

## 📤 Windows'tan App Store Connect'e Yükleme

### Yöntem A: App Store Connect Web Arayüzü (En Kolay)

**⚠️ Not:** App Store Connect web arayüzü doğrudan `.ipa` yüklemesine izin vermez. Ancak GitHub Actions workflow'unuzda otomatik yükleme ekleyebilirsiniz (yukarıdaki workflow'da mevcut).

### Yöntem B: Transporter (macOS Gerektirir - Kullanmayın)

Transporter macOS gerektirir, bu yöntemi kullanmayın.

### Yöntem C: GitHub Actions ile Otomatik Yükleme (Önerilen)

Workflow dosyanızda zaten otomatik yükleme var. Sadece workflow'u çalıştırın ve otomatik olarak App Store Connect'e yüklenir!

### Yöntem D: fastlane (GitHub Actions içinde)

Daha gelişmiş bir yöntem için fastlane kullanabilirsiniz:

```yaml
- name: Install fastlane
  run: |
    sudo gem install fastlane -NV

- name: Upload to App Store Connect
  env:
    APPLE_ID: ${{ secrets.APPLE_ID }}
    APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}
  run: |
    fastlane deliver \
      --ipa "./build/*.ipa" \
      --skip_screenshots \
      --skip_metadata \
      --username "$APPLE_ID" \
      --app_identifier "com.videodownloader.videoindir.tiktok.download.VideoDownloader"
```

---

## 🔧 Yöntem 2: Manuel Build İndirme + Windows'tan Yükleme

Eğer GitHub Actions ile otomatik yükleme istemiyorsanız:

### Adım 1: Build'i İndirin

1. GitHub Actions'tan `.ipa` dosyasını indirin (yukarıdaki Adım 5)

### Adım 2: Windows'tan Yükleme

**Seçenek 1: App Store Connect API (Gelişmiş)**

Python scripti ile Windows'tan yükleyebilirsiniz:

```python
# upload_to_appstore.py
import requests
import os

APPLE_ID = "your-email@example.com"
APP_SPECIFIC_PASSWORD = "your-app-specific-password"
IPA_FILE = "VideoDownloader.ipa"

# App Store Connect API ile yükleme
# Not: Bu yöntem için API key gerekir
```

**Seçenek 2: GitHub Actions Workflow'u Güncelleme**

En kolay yöntem: Workflow dosyanızda otomatik yükleme zaten var. Sadece workflow'u çalıştırın!

---

## 📝 Gelişmiş GitHub Actions Workflow (Tam Otomatik)

Daha gelişmiş bir workflow örneği:

```yaml
name: Build, Archive and Upload to App Store

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version number (e.g., 1.0.7)'
        required: true
        type: string
      build_number:
        description: 'Build number (auto-increment if empty)'
        required: false
        type: string

jobs:
  build-and-upload:
    runs-on: macos-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: latest-stable
    
    - name: Update version and build number
      run: |
        if [ -n "${{ github.event.inputs.version }}" ]; then
          plutil -replace CFBundleShortVersionString -string "${{ github.event.inputs.version }}" VideoDownloader/Info.plist
        fi
        
        BUILD_NUMBER="${{ github.event.inputs.build_number }}"
        if [ -z "$BUILD_NUMBER" ]; then
          BUILD_NUMBER="${{ github.run_number }}"
        fi
        plutil -replace CFBundleVersion -string "$BUILD_NUMBER" VideoDownloader/Info.plist
    
    - name: Build and Archive
      env:
        TEAM_ID: ${{ secrets.TEAM_ID }}
      run: |
        xcodebuild clean archive \
          -workspace VideoDownloader.xcworkspace \
          -scheme VideoDownloader \
          -configuration Release \
          -archivePath ./build/VideoDownloader.xcarchive \
          -allowProvisioningUpdates \
          CODE_SIGN_IDENTITY="Apple Distribution" \
          DEVELOPMENT_TEAM="$TEAM_ID"
    
    - name: Export IPA
      run: |
        xcodebuild -exportArchive \
          -archivePath ./build/VideoDownloader.xcarchive \
          -exportOptionsPlist ./exportOptions.plist \
          -exportPath ./build
    
    - name: Upload IPA as artifact
      uses: actions/upload-artifact@v4
      with:
        name: ios-app-${{ github.run_number }}
        path: build/*.ipa
        retention-days: 30
    
    - name: Upload to App Store Connect
      env:
        APPLE_ID: ${{ secrets.APPLE_ID }}
        APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}
      run: |
        xcrun altool --upload-app \
          --type ios \
          --file ./build/*.ipa \
          --username "$APPLE_ID" \
          --password "$APPLE_APP_SPECIFIC_PASSWORD" \
          --verbose
```

---

## ✅ Adım Adım: İlk Kurulum

### 1. GitHub Repository Hazırlama

```bash
# Projenizi GitHub'a push edin (eğer yoksa)
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/username/repo-name.git
git push -u origin main
```

### 2. GitHub Secrets Ekleme

1. Repository → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** butonuna tıklayın
3. Şu secret'ları ekleyin:
   - `APPLE_ID`: Apple Developer e-posta adresiniz
   - `APPLE_APP_SPECIFIC_PASSWORD`: App-specific password
   - `TEAM_ID`: `NJRDK44KQ5`

### 3. Workflow Dosyası Oluşturma

1. Repository'de `.github/workflows/` klasörü oluşturun
2. `build-and-upload.yml` dosyasını ekleyin (yukarıdaki örnek)
3. `exportOptions.plist` dosyasını proje kök dizinine ekleyin
4. Commit ve push edin

### 4. İlk Build

1. **Actions** sekmesine gidin
2. **Build and Archive iOS App** workflow'unu seçin
3. **Run workflow** → **Run workflow**
4. Build tamamlanınca `.ipa` dosyasını indirin veya otomatik yükleme yapılır

---

## 🎯 Özet: Windows'tan Yükleme Süreci

1. ✅ **GitHub Actions ile build alın** (macOS runner otomatik)
2. ✅ **Build'i indirin** (Artifacts'tan) veya **otomatik yükleyin**
3. ✅ **App Store Connect'te build'i seçin** (web arayüzünden)
4. ✅ **Metadata'yı doldurun** (web arayüzünden)
5. ✅ **İnceleme için gönderin** (web arayüzünden)

**Sonuç:** macOS'a ihtiyaç yok! Sadece GitHub Actions ve Windows yeterli! 🚀

---

## 🆘 Sorun Giderme

### Build Hatası: "Code signing error"
- **Çözüm:** `TEAM_ID` secret'ının doğru olduğundan emin olun
- Provisioning profile'ın otomatik yönetildiğinden emin olun

### Upload Hatası: "Invalid credentials"
- **Çözüm:** App-specific password'ün doğru olduğundan emin olun
- 2FA aktif olmalı

### Workflow Çalışmıyor
- **Çözüm:** `.github/workflows/` klasörünün doğru yerde olduğundan emin olun
- YAML syntax'ını kontrol edin

---

## 📚 Ek Kaynaklar

- **GitHub Actions:** [docs.github.com/actions](https://docs.github.com/actions)
- **Xcode Build Settings:** [developer.apple.com](https://developer.apple.com/)
- **App Store Connect:** [appstoreconnect.apple.com](https://appstoreconnect.apple.com/)

**Başarılar! 🚀**
