# Daftar Task — Kas Kelas

Aturan: satu task = satu sesi AI = satu commit/PR kecil.
Setiap task punya Definition of Done (DoD) yang bisa dites.

## Aktif
- [ ] T-004 Daftar tunggakan
  - DoD: halaman Tunggakan menampilkan siswa aktif yang belum bayar beserta jumlah minggunya, urut terbanyak;
    test `hitung.ts` mencakup siswa baru, siswa nonaktif, dan pergantian tahun
  - Butuh: T-003

## Backlog
- [ ] T-005 Saldo dan pengeluaran
  - DoD: bisa mencatat pengeluaran; saldo = iuran masuk − pengeluaran, dites dengan data contoh
  - Butuh: T-003
- [ ] T-006 Ekspor/impor cadangan JSON
  - DoD: ekspor lalu impor menghasilkan data identik; file rusak/versi salah ditolak dengan pesan jelas
  - Butuh: T-002
- [ ] T-007 Pengingat cadangan
  - DoD: muncul pengingat jika cadangan terakhir > 30 hari atau belum pernah
  - Butuh: T-006

## Selesai
- [x] T-001 Setup project (`make init STACK=react`, Vitest, CI hijau)
  - DoD: `make lint` dan `make test` hijau lokal dan di CI
- [x] T-002 Isi iuran dan daftar siswa, tersimpan setelah reload
  - DoD: bisa menempel daftar nama (satu per baris); data tetap ada setelah halaman dimuat ulang
  - Butuh: T-001
- [x] T-003 Tandai pembayaran minggu ini
  - DoD: ketuk nama → lunas, ketuk lagi → batal; tersimpan setelah reload; minggu berjalan tampil sebagai ISO week
  - Butuh: T-002
