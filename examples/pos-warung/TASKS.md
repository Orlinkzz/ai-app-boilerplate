# Daftar Task — POS Warung

Aturan: satu task = satu sesi AI = satu commit/PR kecil.
Setiap task punya Definition of Done (DoD) yang bisa dites.

## Aktif
- [ ] T-006 Laporan harian pemilik
  - DoD: menampilkan omzet, jumlah transaksi, 5 produk terlaris untuk tanggal terpilih; transaksi batal tidak dihitung;
    kasir yang membuka `/pemilik/laporan` mendapat 403 (dites di server, bukan hanya UI)
  - Butuh: T-005

## Backlog
- [ ] T-007 Batalkan transaksi
  - DoD: hanya pemilik; status jadi `batal`, stok kembali sesuai qty, pembatal tercatat; batal dua kali ditolak
  - Butuh: T-006
- [ ] T-008 Peringatan stok menipis
  - DoD: daftar produk dengan `stok <= batas_menipis` tampil di laporan; dites dengan data batas
  - Butuh: T-003
- [ ] T-009 Batas percobaan login
  - DoD: percobaan gagal ke-6 dalam 15 menit ditolak dengan pesan umum; login berhasil mereset hitungan
  - Butuh: T-002
- [ ] T-010 Backup harian
  - DoD: skrip backup menghasilkan file yang bisa dipulihkan; langkah pemulihan ditulis di `docs/`
  - Butuh: T-001

## Selesai
- [x] T-001 Setup project (`make init STACK=svelte`, Vitest, CI hijau)
  - DoD: `make lint` dan `make test` hijau lokal dan di CI
- [x] T-002 Login, sesi, dan peran
  - DoD: seed membuat akun pemilik; login/logout jalan; password ter-hash; `/pemilik/*` menolak kasir dengan 403
  - Butuh: T-001
- [x] T-003 Kelola produk
  - DoD: pemilik bisa tambah/ubah/nonaktifkan produk; harga dan stok divalidasi (bilangan bulat, harga > 0, stok >= 0)
  - Butuh: T-002
- [x] T-004 Layar kasir: cari produk dan keranjang
  - DoD: cari dengan sebagian nama; tambah/ubah qty/hapus item; total dan kembalian tampil (pratinjau di browser)
  - Butuh: T-003
- [x] T-005 Simpan transaksi
  - DoD: server menghitung ulang harga dan total dari database; stok berkurang atomik dan tidak pernah minus;
    `bayar < total` ditolak; harga tersimpan sebagai snapshot
  - Butuh: T-004
