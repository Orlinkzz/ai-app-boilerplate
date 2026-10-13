# Catatan Keputusan — POS Warung

## 0001 — SvelteKit + SQLite, bukan frontend saja
- Tanggal: 2026-10-05
- Status: diterima
- Konteks: data produk, stok, dan transaksi harus sama di perangkat kasir dan pemilik; kasir tidak boleh bisa
  mengubah harga. Beban kecil (3 perangkat, ~300 transaksi/hari).
- Keputusan: SvelteKit (halaman + server) dengan SQLite satu file.
- Alasan: satu proyek dan satu bahasa; SQLite cukup untuk beban ini dan tidak butuh server database terpisah.
- Alternatif ditolak: React + localStorage (data tidak bisa dibagi, aturan bisa diakali dari browser);
  React + backend Go + PostgreSQL (dua proyek dan satu server database untuk satu warung, terlalu berat dirawat sendiri).
- Konsekuensi: hosting harus punya disk persisten; satu instance saja. Jika nanti multi-cabang,
  pertimbangkan pindah ke PostgreSQL (entri baru).

## 0002 — Uang sebagai bilangan bulat rupiah
- Tanggal: 2026-10-05
- Status: diterima
- Konteks: harga, total, dan kembalian harus tepat; rupiah tidak memakai sen dalam praktik warung.
- Keputusan: semua nilai uang disimpan dan dihitung sebagai `INTEGER` rupiah.
- Alasan: menghindari error pembulatan bilangan desimal (`0.1 + 0.2 !== 0.3`).
- Alternatif ditolak: `REAL`/float (tidak presisi), string (rawan salah saat dihitung).
- Konsekuensi: jika nanti ada diskon persen, pembulatan harus diputuskan eksplisit dan dites.

## 0003 — Snapshot nama dan harga di setiap item transaksi
- Tanggal: 2026-10-08
- Status: diterima
- Konteks: pemilik bisa mengubah harga kapan saja; laporan hari kemarin tidak boleh ikut berubah.
- Keputusan: `transaksi_item` menyimpan `nama_snapshot` dan `harga_snapshot` saat transaksi terjadi.
- Alasan: transaksi adalah catatan sejarah dan tidak boleh berubah.
- Alternatif ditolak: membaca harga dari tabel `produk` saat laporan dibuat (laporan lama berubah setelah harga diganti).
- Konsekuensi: data sedikit berulang; produk tidak dihapus permanen, hanya dinonaktifkan.

## 0004 — Pengurangan stok atomik di database
- Tanggal: 2026-10-12
- Status: diterima
- Konteks: ditemukan saat review T-005 (lihat `SESI-T-005.md`): cek stok lalu update secara terpisah bisa
  menghasilkan stok minus jika dua kasir menjual barang terakhir bersamaan.
- Keputusan: seluruh transaksi dalam satu transaksi database; stok dikurangi dengan
  `UPDATE produk SET stok = stok - ? WHERE id = ? AND stok >= ?`, dan gagal jika tidak ada baris yang berubah.
- Alasan: database yang menjamin aturan stok, bukan urutan kode aplikasi.
- Alternatif ditolak: cek stok di kode aplikasi sebelum update (ada jeda waktu yang bisa diserobot request lain).
- Konsekuensi: kasir bisa menerima pesan "stok tidak cukup" saat menyimpan, walau tadi terlihat tersedia;
  pesan harus jelas.
