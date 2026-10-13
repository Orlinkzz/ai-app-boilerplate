# PRD — POS Warung

## 1. Masalah
Pemilik warung sembako dengan 2 kasir (bergantian shift) mencatat penjualan di buku. Ia tidak tahu omzet harian
sampai menghitung manual di malam hari, sering kehabisan barang laris tanpa sadar, dan sulit memeriksa
apakah uang di laci cocok dengan penjualan.

## 2. Target User
- **Pemilik** (1 orang): mengelola harga dan stok, melihat laporan. Memakai HP Android dan laptop sesekali.
- **Kasir** (2 orang): mencatat penjualan di tablet/HP di meja kasir. Bukan orang teknis, harus cepat saat antre.

## 3. Tujuan & Metrik Sukses
- Kasir bisa menyelesaikan transaksi 5 item dalam < 45 detik.
- Pemilik bisa melihat omzet dan jumlah transaksi hari ini kapan saja, tanpa menghitung manual.
- Selisih antara uang di laci dan laporan aplikasi di akhir shift = Rp0 selama 2 minggu uji coba.
- Kasir tidak bisa mengubah harga atau menghapus transaksi.

## 4. User Stories
- Sebagai kasir, saya ingin mencari produk dengan mengetik sebagian nama, supaya cepat saat antre.
- Sebagai kasir, saya ingin aplikasi menghitung total dan kembalian, supaya tidak salah hitung.
- Sebagai pemilik, saya ingin mengatur nama, harga, dan stok produk, supaya data di kasir selalu benar.
- Sebagai pemilik, saya ingin melihat omzet harian dan produk terlaris, supaya tahu apa yang harus dibeli lagi.
- Sebagai pemilik, saya ingin diberi tahu produk yang stoknya menipis.
- Sebagai pemilik, saya ingin bisa membatalkan transaksi yang salah input, dengan stok kembali otomatis.

## 5. Scope MVP
**Masuk:**
- [ ] Login dengan dua peran: pemilik dan kasir
- [ ] Kelola produk: nama, harga jual, stok (pemilik saja)
- [ ] Transaksi penjualan tunai: cari produk, keranjang, total, uang dibayar, kembalian; stok berkurang otomatis
- [ ] Laporan harian: omzet, jumlah transaksi, produk terlaris, daftar transaksi (pemilik saja)
- [ ] Batalkan transaksi (pemilik saja) dan peringatan stok menipis

**TIDAK masuk (sengaja ditunda):**
- Pembayaran QRIS/e-wallet (tunai dulu)
- Cetak struk ke printer thermal (struk tampil di layar)
- Scan barcode (cari dengan nama dulu)
- Pembelian/restock dari supplier, harga modal, laba
- Multi-cabang, program member, diskon
- Mode offline

## 6. Alur Utama
1. Pemilik login, memasukkan daftar produk beserta harga dan stok awal, lalu membuat akun kasir.
2. Kasir login di awal shift.
3. Pembeli datang: kasir mengetik nama produk, menambah ke keranjang, mengubah jumlah.
4. Kasir memasukkan uang yang diterima → aplikasi menampilkan kembalian → simpan. Stok berkurang.
5. Malam hari: pemilik membuka laporan hari ini dan daftar stok menipis.

## 7. Non-Functional
- Dipakai bersamaan oleh maksimal 3 perangkat; ~300 transaksi per hari; ~500 produk.
- Pencarian produk terasa instan (< 300 ms).
- Uang disimpan sebagai bilangan bulat rupiah, tanpa pecahan.
- Stok tidak boleh minus, termasuk jika dua kasir menjual barang terakhir pada saat bersamaan.
- Password disimpan sebagai hash; sesi kasir habis otomatis setelah 12 jam.
- Data di-backup otomatis setiap hari.

## 8. Risiko & Pertanyaan Terbuka
- Internet warung kadang putus → MVP butuh internet; mode offline ditunda dan dicatat sebagai risiko.
  Mitigasi sementara: catat di buku saat internet mati, input ulang setelahnya.
- Harga berubah di tengah hari → transaksi lama harus tetap memakai harga saat terjadi (simpan snapshot harga).
- Siapa yang membuat akun pemilik pertama? → lewat perintah seed sekali di server, bukan halaman pendaftaran publik.
