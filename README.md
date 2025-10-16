# 🥗 Malzemeye Göre Yemek Öneren Günlük Menü Uygulaması

**Akıllı yemek öneri sistemi — Flutter + FastAPI + PostgreSQL**  
Kullanıcılara eldeki malzemelere göre tarif önerir, günlük menü oluşturma, favorilere ekleme ve alışveriş listesi çıkarma gibi özellikler sunar.

---

## 🚀 Özellikler

✅ Kullanıcı Kayıt ve Giriş  
🧠 Malzemeye Göre Tarif Önerme  
📋 Günlük Menü Oluşturma  
❤️ Favorilere Ekleme/Silme  
🛒 Otomatik Alışveriş Listesi Oluşturma  
✍️ Kullanıcıya Özel Tarif Ekleme ve Düzenleme  
🔍 Kategoriye Göre Filtreleme (Etli, Vejetaryen, vb.)  
🎨 Modern ve mobil uyumlu kullanıcı arayüzü (NumNum benzeri tasarım)

---

## 🛠️ Kullanılan Teknolojiler

| Katman | Teknoloji |
|--------|------------|
| **Mobil** | Flutter |
| **Backend** | FastAPI |
| **Veritabanı** | PostgreSQL (UTF8, tr_TR) |
| **Diğer** | HTTP, RESTful API |

---

## 📂 Proje Yapısı

```
yemek_menu_proje/
├── backend/           # FastAPI backend (main.py, models, routes)
├── lib/               # Flutter app code
│   ├── screens/       # Ekranlar (login, menu, recipe, etc.)
│   ├── models/        # Recipe, User vs.
│   ├── services/      # API servisleri
├── gyk_tr_schema.sql  # Veritabanı şeması ve başlangıç verileri
```

---

## ⚙️ Kurulum Talimatları

### 🔸 1. Veritabanı Kurulumu (PostgreSQL)

```bash
# Veritabanını oluştur
createdb gyk_tr --encoding=UTF8 --locale=tr_TR.UTF-8 --template=template0 -U postgres

# Şemayı yükle
psql -U postgres -d gyk_tr -f gyk_tr_schema.sql
```

### 🔸 2. FastAPI Backend Başlatma

```bash
uvicorn main:app --reload
```

➡️ Backend `http://localhost:8000` adresinde çalışır.

### 🔸 3. Flutter Uygulamasını Çalıştırma

```bash
flutter pub get
flutter run
```

📱 Android emülatör ya da bağlı cihaz gereklidir.

---

## 📬 API Endpointleri (Örnek)

| Endpoint | Açıklama |
|-----------|-----------|
| `POST /register` | Kullanıcı kaydı |
| `POST /login` | Kullanıcı girişi |
| `GET /recipes-by-ingredients/{username}` | Malzemeye göre tarif öner |
| `POST /favorites/{username}` | Favori ekle |
| `DELETE /favorites/{username}/{id}` | Favori sil |
| `GET /menu/{username}` | Günlük menü getir |
| `POST /menu-with-data/{username}` | Menüye tarif ekle |
| `GET /shopping-list/{username}` | Alışveriş listesi oluştur |

---

## 👤 Geliştirici

**📛 Handan İpek**  
🎓 Bilgisayar Mühendisliği, İstanbul Sabahattin Zaim Üniversitesi  
📧 ipekhandan6@gmail.com 
📍 İstanbul, Türkiye  
💻 Mobil • Yapay Zeka • Web Geliştirme   

---

## 💡 Gelecek Geliştirmeler

📸 Görsel ile tarif arama (image classification)  
📅 Haftalık menü planlayıcı  
🧾 PDF alışveriş listesi oluşturma ve dışa aktarma  
🔔 Fatura / alışveriş hatırlatıcı entegrasyonu  
👨‍👩‍👧 Çok kullanıcı destekli aile menü planı  

---

## 📄 Lisans

**MIT License © 2025 Handan İpek**
