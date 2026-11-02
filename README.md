# 📚 Aplikasi Perpustakaan Mini (UTS Pemrograman Multi Platform)

Aplikasi manajemen peminjaman buku berbasis mobile yang dibangun menggunakan **Flutter**, **Firebase (Auth & Cloud Firestore)**, dan **Dio REST API**. Proyek ini dibuat untuk memenuhi tugas Ujian Tengah Semester (UTS) mata kuliah Pemrograman Multi Platform, Semester Ganjil TA 2026/2027.

---

## 👥 Tabel Anggota Kelompok & Peran Baku

| NIM            | Nama                 | Peran Baku UTS | Deskripsi Tanggung Jawab                                                                          |
| :------------- | :------------------- | :------------- | :------------------------------------------------------------------------------------------------ |
| **2411500032** | **Rifqi Al Ghifari** | Anggota 1      | Auth + Navigasi + Struktur Folder                                                                 |
| **2411500024** | **Jibran Pratama**   | Anggota 2      | Firestore CRUD + Model/Service/Provider + ViewState (Write: Add, Update, Delete)                  |
| **2411500013** | **Rifky Peratama**   | Anggota 3      | Dio REST API + loading/error/empty + Future vs Stream                                             |
| **2411500008** | **Muhamad Julfandi** | Anggota 4      | Firestore CRUD + Model/Service/Provider + ViewState (Read: Realtime Stream & Client-side Sorting) |

---

## 🚀 Fitur Utama Aplikasi

1. **Firebase Authentication (Auth)**:
   - Registrasi akun baru, Login, dan Logout.
   - Pemantauan status login pengguna secara _real-time_ menggunakan `Stream<User?>` (`authStateChanges()`).

2. **Firestore CRUD Data Utama (`books`)**:
   - **Create**: Menambahkan data koleksi buku baru.
   - **Read (Stream)**: Menampilkan daftar buku secara _real-time_ menggunakan `.snapshots()`.
   - **Update**: Mengubah detail buku serta memperbarui status (_Tersedia_ / _Dipinjam_) dan nama peminjam.
   - **Delete**: Menghapus koleksi buku dari database.
   - **Client-side Sorting**: Pengurutan data dilakukan di sisi client (Dart) berdasarkan `borrowedAt` (`Timestamp`) tanpa `orderBy` Firestore (Sesuai aturan P05 UTS).

3. **State Management & Provider**:
   - Menggunakan 3 `ChangeNotifier` (`AuthProvider`, `BookProvider`, `ApiProvider`) dan `MultiProvider` pada `main.dart`.
   - Manajemen tampilan berorientasi `ViewState` (`loading`, `loaded`, `error`, `empty`).
   - Dispose `StreamSubscription` secara otomatis untuk mencegah kebocoran memori (_memory leak_).

4. **REST API Read-Only (Dio)**:
   - Mengambil data katalog referensi eksternal dari JSONPlaceholder API menggunakan package `Dio`.
   - Dilengkapi penanganan `ViewState`: _loading spinner_, _error message retry_, dan _empty state_.
   - Navigasi halaman katalog dari `ListApiScreen` ke `DetailApiScreen`.

---

## 📸 Screenshot Aplikasi

|             Halaman Auth / Login              |        Halaman Home CRUD (Firestore)        |              Halaman Katalog API (Dio)              |                   Halaman Detail API                    |
| :-------------------------------------------: | :-----------------------------------------: | :-------------------------------------------------: | :-----------------------------------------------------: |
| ![Login Screen](assets/screenshots/login.png) | ![Home Screen](assets/screenshots/home.png) | ![List API Screen](assets/screenshots/api_list.png) | ![Detail API Screen](assets/screenshots/api_detail.png) |

---

## 💻 Panduan Menjalankan Aplikasi

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek di perangkat lokal / emulator.

### 1. Prasyarat Sistem

- Flutter SDK (Versi `3.0.0` atau yang lebih baru)
- Dart SDK
- Git & Firebase CLI

### 2. Clone Repository

```bash
git clone https://github.com/Perpustakaan-Mini-UTS/Perpustakaan-Mini-UTS.git
cd uts-pmp-perpustakaan-mini
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Konfigurasi Firebase (`flutterfire configure`)

Proyek ini menggunakan Firebase backend. File `lib/firebase_options.dart` sudah **dideklarasikan dan di-commit ke dalam repository ini** agar dapat langsung dijalankan oleh dosen.

Jika ingin menghubungkan kembali ke proyek Firebase lokal:

1. Pastikan Firebase CLI sudah terinstall dan terotentikasi:
   ```bash
   firebase login
   ```
2. Jalankan perintah `flutterfire configure` pada root folder proyek:
   ```bash
   flutterfire configure
   ```
3. Pilih proyek Firebase target, lalu tekan **Enter**. File `lib/firebase_options.dart` akan dikonfigurasi ulang secara otomatis.

### 5. Jalankan Aplikasi

```bash
flutter run
```

---

## 📌 Catatan File Konfigurasi Firebase

File `lib/firebase_options.dart` **WAJIB di-commit ke Git** dan **TIDAK BOLEH** dimasukkan ke dalam file `.gitignore` sesuai ketentuan instruksi UTS Pemrograman Multi Platform.

---

## 🎬 Link Video Presentasi & Bedah Kode (Zoom)

- **Link Google Drive Video**: [Klik Di Sini Untuk Menonton Video Zoom UTS](https://drive.google.com/YOUR_VIDEO_LINK_HERE)
- **Ketentuan Video**:
  - Format: Gallery view Zoom (Semua anggota on-cam pada 1 menit pertama).
  - Durasi: 12 - 15 Menit (Kelompok 4 Orang).
  - Pembagian giliran _screen-share_ dan pemaparan materi minimal 3 menit per anggota.
