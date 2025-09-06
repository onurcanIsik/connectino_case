# 📒 Connectino Case – Flutter Notes App

Basit ama üretim kalitesinde mimariyle geliştirilmiş, **offline-first not uygulaması**.  
Bu proje Flutter istemci + FastAPI backend içeren bir case study’dir.  
Amaç: **Kimlik doğrulama, not CRUD, offline cache, senkronizasyon ve backend API** becerilerini göstermektir.

---

## 🚀 Özellikler
- 🔐 **Authentication**: Firebase ile kullanıcı kayıt/giriş/çıkış  
- 📝 **Notes CRUD**: Not oluşturma, listeleme, güncelleme, silme  
- 🔄 **Offline-first**: Hive ile notları offline saklama, internet gelince otomatik sync  
- 🌐 **Backend API**: FastAPI ile REST uç noktaları (`/notes`)  
- 🧭 **Navigasyon**: AutoRoute ile sayfa geçişleri  
- 🧰 **State Management**: Riverpod ile global state  

---

## 📸 Demo
https://github.com/user-attachments/assets/857131f5-f262-4876-a3ff-0b5a31c3d8da

---

## 🛠️ Teknolojiler
- Flutter 3.x, Dart 3  
- Riverpod (state)  
- AutoRoute (routing)  
- Firebase (Auth + Firestore)  
- Hive (offline cache)  
- Dio (HTTP client + interceptor)  
- FastAPI (backend, Python)

## 🔮 Gelecek / AI Entegrasyonu
Connectino Case şu anda **offline-first not uygulaması** olarak çalışıyor.  
Ancak ileride **AI desteği** eklenerek daha akıllı hale getirilebilir. Örneğin:  

- 📷 **Kamera ile OCR (Optical Character Recognition)**:  
  Kullanıcı kamerayı açıp bir belge veya yazıyı tarar.  

- 🤖 **AI Destekli Özetleme**:  
  Taranan metin **LLM (Large Language Model)** ile kısaltılır ve özetlenir.  

- 📝 **Otomatik Not Ekleme**:  
  AI tarafından oluşturulan kısa ve öz metin, uygulamaya otomatik olarak not olarak kaydedilir.  

➡️ Böylece kullanıcılar uzun yazıları tarayıp saniyeler içinde basit ve anlaşılır notlara dönüştürebilir.


## 📂 Klasör Yapısı

```plaintext
lib/
 ├─ core/
 │   ├─ api/                     # API client ve servisler
 │   ├─ app/                     # App widget, MaterialApp.router
 │   ├─ box/                     # Hive kutuları, local cache işlemleri
 │   ├─ connection/              # internet kontrolü (online/offline)
 │   ├─ constant/                # sabitler
 │   ├─ extensions/              # yardımcı extensionlar
 │   ├─ helper/                  # init, guards, app_helper, auto_route_guard
 │   ├─ hive/                    # Hive ile ilgili işlemler
 │   ├─ models/                  # ortak modeller (user_model, notes_model, dto’lar)
 │   ├─ network/                 # dio_provider, network providers
 │   ├─ utils/                   # enumlar, yardımcı fonksiyonlar
 │   └─ router/                  # app_router ve auto_route config
 │
 ├─ features/
 │   ├─ auth/                    # Authentication
 │   │   ├─ repo/                # auth repository
 │   │   ├─ view/                # ekranlar (auth_page)
 │   │   └─ view_model/          # notifierlar, state
 │   │
 │   ├─ home/                    # Notlar için home ekranı
 │   │   ├─ view/
 │   │   └─ view_model/
 │   │
 │   ├─ offline/                 # OfflinePage, offline not gösterimi
 │   │
 │   └─ splash/                  # Splash ekranı
 │
 ├─ widgets/                     # tekrar kullanılabilir widget’lar
 │   └─ homeWidget/              # HomePage ile ilgili bottom_sheet, note_detail_sheet
 │
 └─ main.dart                    # uygulama giriş noktası

---

## ⚙️ Kurulum

### 📱 Frontend (Flutter)

#### Gereksinimler
- Flutter 3.x (Dart 3)
- Android Studio / Xcode (geliştirme ortamı)
- Firebase projesi (Auth + Firestore aktif)
- Node.js (opsiyonel, Firebase CLI için)

#### Adımlar
```bash
# 1) Projeyi klonla
git clone https://github.com/onurcanIsik/connectino_case.git
cd connectino_case

# 2) Flutter bağımlılıklarını yükle
flutter pub get

# 3) Uygulamayı çalıştır
flutter run
