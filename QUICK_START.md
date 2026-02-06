# RetroBat macOS Port - Quick Start Guide

## Genel Bakış (Overview in Turkish)

Bu rehber, RetroBat'ın Windows'tan macOS Apple Silicon'a taşınması için ilk adımları içerir.

**Not**: Bu proje büyük bir çalışmadır ve yaklaşık 16 hafta sürmesi beklenmektedir.

## Ana Zorluklar (Main Challenges)

1. **C# .NET Uygulamaları** - RetroBuild.exe ve emulatorLauncher Windows .NET Framework kullanıyor
2. **EmulationStation** - Windows için özel build, macOS versiyonu yok
3. **Binlerce Yapılandırma Dosyası** - Windows yolları ve ayarları içeriyor
4. **Emülatör Uyumluluğu** - Bazı emülatörlerin macOS versiyonu yok

## Önerilen Çözümler (Recommended Solutions)

1. **.NET 6+** - Çapraz platform desteği için (Windows + macOS)
2. **ES-DE** - EmulationStation Desktop Edition (zaten macOS desteği var)
3. **SDL3** - Kontrol cihazları için (macOS uyumlu)
4. **Otomatik Script'ler** - Yapılandırma dosyalarını toplu değiştirmek için

## Hemen Yapılacaklar (Immediate Next Steps)

### 1. Geliştirme Ortamı Kurulumu

macOS'ta şunları yükleyin:

```bash
# Homebrew (paket yöneticisi)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# .NET 8 SDK (en güncel cross-platform)
brew install dotnet

# Gerekli araçlar
brew install p7zip wget sdl3

# Git ve Xcode Command Line Tools (genelde zaten yüklü)
xcode-select --install
```

### 2. Kaynak Kod Deposu

```bash
# emulatorLauncher kaynak kodunu klonlayın
git clone https://github.com/RetroBat-Official/emulatorlauncher.git

# EmulationStation kaynak kodunu klonlayın (referans için)
git clone https://github.com/RetroBat-Official/emulationstation.git
```

### 3. EmulationStation-DE Test

```bash
# ES-DE'yi indirin
# https://es-de.org/#macos

# Test edin ve RetroBat yapılandırmalarıyla uyumluluğunu kontrol edin
```

### 4. Proje Planlaması

Tamamlanmış planlar:
- ✅ `MACOS_MIGRATION_PLAN.md` - Detaylı teknik plan
- ✅ `ISSUES.md` - GitHub issue şablonları

## Proje Aşamaları (Project Phases)

### Aşama 1: Hazırlık (Hafta 1-2)
- Geliştirme ortamı
- Araştırma ve planlama
- Prototip testleri

### Aşama 2: Temel Bileşenler (Hafta 3-5)
- RetroBuild'i .NET 6+'ya taşıma
- Sistem araçlarını değiştirme
- EmulationStation entegrasyonu

### Aşama 3: Emülatör Başlatıcı (Hafta 6-8)
- emulatorLauncher'ı .NET 6+'ya taşıma
- Kontrol cihazı desteği (SDL3)
- Process management

### Aşama 4: Emülatör Uyumluluğu (Hafta 8-10)
- RetroArch entegrasyonu
- Standalone emülatörler
- Uyumluluk testi

### Aşama 5: Yapılandırma (Hafta 10-11)
- Tüm config dosyalarını güncelleme
- Yol değişiklikleri
- Platform-specific ayarlar

### Aşama 6: Paketleme (Hafta 11-13)
- .dmg/.pkg installer
- Code signing
- Build otomasyonu

### Aşama 7: Test & Dokümantasyon (Hafta 13-15)
- Beta test
- Performans optimizasyonu
- Kullanıcı dokümantasyonu

### Aşama 8: Yayın (Hafta 15-16)
- Release hazırlığı
- Dağıtım
- Topluluk duyurusu

## Kritik Kararlar (Critical Decisions)

### 1. EmulationStation Seçimi
**Karar**: ES-DE kullan (yeniden portlamak yerine)
**Neden**: 
- Zaten macOS desteği var
- Aktif geliştirme
- Apple Silicon optimizasyonlu

### 2. .NET Versiyonu
**Karar**: .NET 6+ (veya .NET 8)
**Neden**:
- Tam cross-platform destek
- Modern ve desteklenen
- Performans iyileştirmeleri

### 3. Kontrol Cihazları
**Karar**: SDL3
**Neden**:
- Cross-platform
- Modern controller desteği
- Bluetooth ve USB

### 4. Build Sistemi
**Karar**: Shell script + .NET
**Neden**:
- macOS native
- Basit ve anlaşılır
- Otomasyona uygun

## İlk Prototip Hedefleri (Initial Prototype Goals)

Minimal çalışan versiyonu oluşturun:

1. ✅ EmulationStation-DE çalışıyor
2. ✅ RetroArch başlatılabiliyor
3. ✅ 1 emülatör çalışıyor (örnek: NES)
4. ✅ Kontrol cihazı çalışıyor
5. ✅ ROM yükleme çalışıyor

Bu basit prototip, geri kalan işin temelini oluşturacak.

## Geliştirici Notları (Developer Notes)

### Önemli Repository'ler
- **Bu Repo**: https://github.com/bayramog/retrobat-macos
- **Ana RetroBat**: https://github.com/RetroBat-Official/retrobat
- **emulatorLauncher**: https://github.com/RetroBat-Official/emulatorlauncher
- **EmulationStation**: https://github.com/RetroBat-Official/emulationstation
- **ES-DE**: https://gitlab.com/es-de/emulationstation-de

### Faydalı Linkler
- ES-DE Dokümantasyon: https://es-de.org/
- RetroArch macOS: https://www.retroarch.com/?page=platforms
- .NET Cross-Platform: https://docs.microsoft.com/en-us/dotnet/core/
- SDL3: https://wiki.libsdl.org/SDL3/

## Test Ortamı Gereksinimleri

### Minimum
- macOS Ventura (13.0) veya üstü
- Apple Silicon (M1) veya Intel
- 8 GB RAM
- 20 GB disk alanı

### Önerilen
- macOS Sonoma (14.0) veya üstü
- Apple Silicon (M2 veya M3)
- 16 GB RAM
- 50 GB disk alanı
- Xbox veya PlayStation controller

## Katkıda Bulunma (Contributing)

Bu büyük bir proje ve katkılara açık!

### Yardım Edilebilecek Alanlar
1. **Test**: macOS'ta emülatörleri test etme
2. **Dokümantasyon**: Türkçe/İngilizce dokümantasyon
3. **Emülatör Yapılandırması**: Belirli emülatörleri ayarlama
4. **Controller Testi**: Farklı controller'ları test etme
5. **UI/UX**: EmulationStation tema uyumluluğu

### Issue'lar Oluşturmak

`ISSUES.md` dosyasındaki şablonları kullanarak GitHub'da issue'lar oluşturun:

```bash
# Örnek issue başlıkları:
- "Setup macOS Development Environment"
- "Port RetroBuild to .NET 6+"
- "Replace System Tools with macOS Equivalents"
- "Integrate EmulationStation-DE for macOS"
- "Port emulatorLauncher to .NET 6+"
```

Her issue için:
1. Açık başlık
2. Detaylı açıklama
3. Görevler listesi (checklist)
4. Kabul kriterleri
5. İlgili etiketler (labels)

## Başarı Kriterleri (Success Criteria)

### Minimum Çalışır Ürün (MVP)
- [ ] RetroBat macOS'ta başlatılıyor
- [ ] EmulationStation arayüzü çalışıyor
- [ ] RetroArch entegre
- [ ] En az 5 sistem çalışıyor
- [ ] Controller desteği var
- [ ] .dmg installer var

### Tam Sürüm
- [ ] Tüm test edilebilir emülatörler çalışıyor
- [ ] Komple dokümantasyon
- [ ] Code signing ve notarization
- [ ] CI/CD pipeline
- [ ] Beta test tamamlandı
- [ ] Windows versiyonuyla eşit performans

## Bilinen Zorluklar (Known Challenges)

### Teknik
1. **emulatorLauncher Karmaşıklığı** - Derin Windows bağımlılıkları olabilir
2. **Emülatör Uyumluluğu** - Bazı emülatörlerin macOS versiyonu yok
3. **Performans** - Apple Silicon optimizasyonu gerekebilir
4. **Code Signing** - Apple Developer hesabı ve süreç

### Organizasyonel
1. **Zaman** - 16 haftalık ciddi geliştirme
2. **Test** - Çok sayıda emülatör ve sistem
3. **Dokümantasyon** - Hem Türkçe hem İngilizce
4. **Bakım** - Hem Windows hem macOS versiyonunu sürdürme

## Öncelikli Görevler (Priority Tasks)

### Bu Hafta
1. Geliştirme ortamını kur
2. EmulationStation-DE'yi test et
3. emulatorLauncher kaynak kodunu incele
4. İlk prototipi planla

### Gelecek Hafta
1. RetroBuild'i .NET 6+'ya taşımaya başla
2. Sistem araçlarını değiştir
3. İlk konfigürasyon dosyalarını güncelle
4. RetroArch'ı indir ve test et

### Bu Ay
1. Çalışan prototip oluştur
2. Ana emülatörleri entegre et
3. Build scriptlerini yaz
4. İlk beta versiyonu

## İletişim ve Destek (Contact & Support)

### Topluluk
- RetroBat Discord: https://discord.gg/GVcPNxwzuT
- RetroBat Forum: https://social.retrobat.org/forum

### Bu Proje
- GitHub Repo: https://github.com/bayramog/retrobat-macos
- Issues: https://github.com/bayramog/retrobat-macos/issues

## Lisans (License)

RetroBat LGPL v3 lisansı altındadır. Bu port da aynı lisansı takip edecek.

---

## Sonraki Adım (Next Step)

**Issue'ları Oluştur!**

`ISSUES.md` dosyasındaki her bir issue şablonunu GitHub'a ekleyin ve projeyi takip etmeye başlayın.

```bash
# GitHub web arayüzünden:
# 1. Issues sekmesine git
# 2. "New issue" butonuna tıkla
# 3. ISSUES.md'den ilgili şablonu kopyala
# 4. Uygun etiketleri ekle
# 5. Milestone ata (varsa)
# 6. Issue'yu oluştur
```

Tüm issue'lar oluşturulduktan sonra, bir project board (Kanban) oluşturarak ilerlemeyi görselleştirin!

---

**İyi şanslar! Başarılar!** 🚀
