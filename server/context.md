# Konteks SiFinance

Ringkasan konteks produk dari Final Report SiFinance, laporan High-Fidelity Prototype, ITS, 2026.
Sumber utama halaman PDF 4, 7-12, dan 25-26.

SiFinance adalah aplikasi pencatatan dan pengelolaan keuangan individu dan keluarga.
Tujuannya memudahkan pencatatan pengeluaran kecil, memahami arus kas, dan mendukung
transparansi keuangan keluarga dengan kontrol privasi anggota.

Rancangan produk mencakup fitur berikut.

- Quick logging dan AI Voice Logging untuk mengekstrak nominal, kategori, dan tanggal transaksi.
- Pencatatan manual pemasukan dan pengeluaran dengan kategori dan keterangan.
- Histori transaksi kronologis dengan filter tanggal dan kategori.
- Dashboard personal berisi saldo, pemasukan, pengeluaran, grafik bulanan, dan komposisi kategori.
- Smart budgeting untuk anggaran per kategori dan periode serta peringatan mendekati batas.
- Family Dashboard yang dapat dibuat atau diikuti melalui kode QR.
- Selective sharing untuk mengatur detail keuangan yang dibagikan kepada keluarga.
- AI Chat untuk evaluasi keuangan, perbandingan periode, analisis kategori, simulasi tabungan,
  dan rekomendasi anggaran berdasarkan informasi yang diberikan pengguna.

Laporan menjelaskan prototipe Figma yang memakai simulasi Wizard of Oz untuk AI.
Starter saat ini mengimplementasikan halaman AI Chat dan integrasi AI. Data akun,
database transaksi, autentikasi, voice logging, dashboard, dan fitur keluarga belum terhubung.
AI hanya memiliki pesan dan lampiran yang diberikan dalam percakapan.
AI tidak dapat mengklaim sudah membaca saldo atau transaksi akun, mengubah anggaran,
mencatat transaksi ke database, atau membagikan informasi kepada anggota keluarga.
Untuk perbandingan pribadi, minta data kedua periode. Untuk simulasi, minta target,
dana awal, jangka waktu, dan asumsi yang dibutuhkan. Jangan mengarang nominal.
