# SiFinance

> **Spend wise. life nice.**

SiFinance adalah aplikasi pengelolaan keuangan pribadi dan keluarga yang dikembangkan menggunakan **Flutter**. Aplikasi ini bertujuan mempermudah pencatatan transaksi, pengaturan anggaran, dan pemantauan arus kas sehari-hari dalam satu tempat.

Repositori ini berisi pengembangan aplikasi Flutter berdasarkan [prototipe desain SiFinance](https://sifinance.framer.website/).

> [!NOTE]
> **Status pengembangan:** Tahap awal. Repositori ini dibuat menggunakan `flutter create sifinance`. Fitur-fitur di bawah masih berupa rencana berdasarkan prototipe dan belum diimplementasikan.

## Fitur yang Direncanakan

| Fitur | Deskripsi | Status |
| --- | --- | --- |
| **Dashboard** | Menampilkan ringkasan kondisi keuangan dan arus kas. | Direncanakan |
| **Pengelolaan Anggaran** | Menetapkan anggaran pengeluaran dan memantau penggunaannya. | Direncanakan |
| **Pencatatan Transaksi Manual** | Mencatat pemasukan dan pengeluaran beserta detail transaksinya. | Direncanakan |
| **Pencatatan Berbantuan AI** | Mempermudah pencatatan transaksi dengan bantuan kecerdasan buatan. | Direncanakan |

## Teknologi

- **Flutter** — Framework untuk pengembangan aplikasi lintas platform.
- **Dart** — Bahasa pemrograman yang digunakan.

Paket tambahan, penyimpanan data, dan integrasi AI akan didokumentasikan setelah dipilih dan diimplementasikan.

## Memulai

### Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terpasang dan dikonfigurasi.
- Perangkat, emulator, atau browser yang mendukung Flutter.

Periksa lingkungan pengembangan:

```bash
flutter doctor
```

### Instalasi

```bash
git clone https://github.com/b4r1e/SIfinance.git sifinance/
cd sifinance
flutter pub get
```


### Menjalankan Aplikasi

Lihat perangkat yang tersedia:

```bash
flutter devices
```

Jalankan aplikasi:

```bash
flutter run
```

Untuk menjalankan pada perangkat tertentu, gunakan `flutter run -d <device-id>`.

> Saat ini aplikasi masih menampilkan tampilan bawaan Flutter hingga antarmuka SiFinance selesai diimplementasikan.

## Struktur Proyek

Repositori saat ini masih menggunakan struktur proyek bawaan Flutter:

```text
sifinance/
├── android/          # Konfigurasi platform Android
├── ios/              # Konfigurasi platform iOS
├── lib/
│   └── main.dart     # Titik masuk aplikasi
├── test/              # Pengujian otomatis
├── pubspec.yaml      # Dependensi dan metadata proyek
└── README.md
```

Direktori platform lain mungkin tersedia, tergantung platform yang diaktifkan saat proyek dibuat.

## Rencana Pengembangan

- [x] Membuat proyek Flutter.
- [ ] Mengimplementasikan sistem desain dan navigasi.
- [ ] Membuat dashboard keuangan.
- [ ] Mengimplementasikan pencatatan transaksi manual.
- [ ] Menambahkan pembuatan dan pemantauan anggaran.
- [ ] Mengintegrasikan pencatatan transaksi berbantuan AI.
- [ ] Menambahkan penyimpanan data dan pengujian aplikasi.

Rencana pengembangan ini dapat berubah sesuai kebutuhan proyek.

## Referensi Desain

Pengembangan aplikasi mengacu pada prototipe desain SiFinance.

- [Website SiFinance](https://sifinance.framer.website/)

