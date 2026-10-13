# Arsitektur — POS Warung

## Status
- Stack dipilih: svelte (`make init STACK=svelte`)

## Gambaran Umum
Satu aplikasi SvelteKit yang menyajikan halaman sekaligus menjalankan logika server. Semua aturan bisnis
(harga, total, stok, hak akses) dijalankan di server; browser hanya menampilkan dan mengirim pilihan pengguna.

```
[Browser kasir/pemilik] ──form action──▶ [SvelteKit server] ──▶ [lib/server/*: aturan bisnis] ──▶ SQLite (1 file)
                                              │
                                     hooks.server.ts: cek sesi + peran di setiap request
```

## Tech Stack & Alasan
| Layer | Pilihan | Alasan |
|---|---|---|
| Web + server | SvelteKit + TypeScript | Halaman dan backend dalam satu proyek; template `svelte` sudah teruji |
| Database | SQLite (satu file) | 3 perangkat, ~300 transaksi/hari; tidak perlu server database terpisah. Lihat DECISIONS 0001 |
| Akses DB | Query builder dengan parameter (tanpa string SQL rakitan) | Aturan keamanan di `AGENTS.md` |
| Password | Library hashing yang sudah teruji (argon2/bcrypt) | Jangan membuat hashing sendiri |
| Test | Vitest | Konvensi stack `svelte` |
| Hosting | Platform yang mendukung SvelteKit server **dan disk persisten**, atau VPS kecil | SQLite butuh file yang tidak hilang saat redeploy |

## Struktur Folder
```
src/hooks.server.ts                sesi + peran → event.locals.user
src/lib/server/db.ts               koneksi + migrasi
src/lib/server/auth.ts             login, sesi, requireRole()
src/lib/server/produk.ts           CRUD produk
src/lib/server/transaksi.ts        simpanTransaksi(), batalkan()
src/lib/server/laporan.ts          omzet harian, terlaris, stok menipis
src/routes/login/                  form login
src/routes/kasir/                  halaman transaksi (kasir & pemilik)
src/routes/pemilik/produk/         kelola produk (pemilik)
src/routes/pemilik/laporan/        laporan (pemilik)
src/lib/server/*.test.ts           test aturan bisnis
```

## Skema Database
```
users          (id, nama, username UNIQUE, password_hash, role CHECK IN ('pemilik','kasir'), aktif)
sessions       (id TEXT acak, user_id → users, expires_at)
produk         (id, nama, harga INTEGER > 0, stok INTEGER >= 0, batas_menipis INTEGER, aktif)
transaksi      (id, kasir_id → users, waktu, total INTEGER, bayar INTEGER, kembalian INTEGER,
                status CHECK IN ('selesai','batal'), dibatalkan_oleh → users NULL)
transaksi_item (id, transaksi_id → transaksi, produk_id → produk,
                nama_snapshot, harga_snapshot INTEGER, qty INTEGER > 0, subtotal INTEGER)
```
Index: `produk(nama)`, `transaksi(waktu)`, `transaksi_item(transaksi_id)`.

## API (SvelteKit form actions)
| Method | Path | Peran | Deskripsi |
|---|---|---|---|
| POST | `/login` | publik | Login, buat sesi (cookie `httpOnly`, `secure`, `sameSite=lax`) |
| POST | `/logout` | login | Hapus sesi |
| GET | `/kasir?q=` | kasir, pemilik | Cari produk aktif |
| POST | `/kasir?/bayar` | kasir, pemilik | Body: `[{produkId, qty}]`, `bayar`. Server menghitung harga & total |
| GET/POST | `/pemilik/produk` | pemilik | Daftar, tambah, ubah produk |
| GET | `/pemilik/laporan?tanggal=` | pemilik | Omzet, jumlah transaksi, terlaris, stok menipis |
| POST | `/pemilik/laporan?/batal` | pemilik | Batalkan transaksi, kembalikan stok |

## Auth & Otorisasi
- Akun pemilik pertama dibuat dengan skrip seed sekali jalan; tidak ada halaman daftar publik.
- Pemilik membuat akun kasir. Sesi berlaku 12 jam.
- `hooks.server.ts` memuat user dari cookie sesi. Setiap action/load di `/pemilik/*` memanggil
  `requireRole('pemilik')` di server; menyembunyikan tombol di UI **tidak** dianggap pengamanan.
- Login dibatasi 5 percobaan gagal per username per 15 menit.

## Integrasi Eksternal
Tidak ada di MVP.

## Deployment
- Satu instance aplikasi + file SQLite di disk persisten.
- Backup harian: salin file database (dengan perintah backup SQLite, bukan salin file saat ada penulisan) ke penyimpanan terpisah.
- Rollback: deploy ulang versi sebelumnya; migrasi database hanya menambah kolom/tabel di MVP.
