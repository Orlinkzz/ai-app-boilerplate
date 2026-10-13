# Contoh Satu Putaran Task: T-005 Simpan Transaksi

Ringkasan sesi kerja dengan AI untuk task yang menyentuh **uang dan stok**. Percakapan dipersingkat.
Perhatikan bahwa implementasi pertama lolos test tapi tetap punya bug serius, dan bug itu ditemukan oleh
review dan audit di **sesi AI baru**.

## 1. Rencana (`prompts/04-plan-task.md`)

Rencana dari AI:
1. `src/lib/server/transaksi.ts`: `simpanTransaksi(kasirId, items, bayar)`
2. Form action `?/bayar` di `src/routes/kasir/+page.server.ts` memanggil fungsi itu
3. Simpan `transaksi` + `transaksi_item` dengan snapshot nama/harga (DECISIONS 0003), kurangi stok
4. Test: total benar, kembalian benar, `bayar < total` ditolak, stok berkurang
5. Di luar scope: struk cetak, pembatalan (T-007)

**Dicek manusia:** rencana sesuai DoD. Pemilik menambahkan satu permintaan ke rencana: "harga harus diambil
dari database, jangan dari form". Rencana disetujui.

## 2. Implementasi (`prompts/05-implement-task.md`)

AI melaporkan:
```
make test  → 31 passed
make lint  → 0 problems
DoD: terpenuhi
```

**Dicek manusia:** mencoba satu transaksi di browser, total dan stok terlihat benar. Kelihatannya beres.

## 3. Review dan audit keamanan (`06-review-code` + `07-security-audit`, sesi AI baru)

Karena task ini menyentuh uang, kedua prompt dijalankan. Temuannya:

```
[KRITIS] src/routes/kasir/+page.server.ts:18 — action membaca field "harga" dari form untuk tiap item
         dan meneruskannya ke simpanTransaksi(). Fungsi itu memakai harga dari DB untuk snapshot, tapi
         memakai harga dari form untuk menghitung total.
         Skenario: kasir mengubah harga lewat DevTools → total lebih murah, laporan omzet ikut salah.
         Perbaikan: action hanya menerima produkId dan qty; total dihitung dari harga DB saja.

[KRITIS] src/lib/server/transaksi.ts:41 — qty tidak divalidasi. qty = -5 menghasilkan subtotal negatif
         dan stok BERTAMBAH 5.
         Perbaikan: qty harus bilangan bulat 1..999; tolak selain itu. Tambah test qty 0, negatif, desimal.

[TINGGI] src/lib/server/transaksi.ts:52 — stok dicek dengan SELECT lalu dikurangi dengan UPDATE terpisah.
         Dua kasir yang menjual barang terakhir bersamaan bisa membuat stok -1.
         Perbaikan: UPDATE ... WHERE stok >= qty dalam satu transaksi DB, gagal jika 0 baris berubah.

[KECIL]  src/routes/kasir/+page.svelte:77 — tombol "Bayar" bisa ditekan dua kali → transaksi ganda.
         Perbaikan: nonaktifkan tombol saat request berjalan.
```

**Kenapa test tidak menangkapnya?** Semua test memanggil `simpanTransaksi()` dengan data yang "wajar".
Tidak ada test yang mencoba input jahat atau dua request bersamaan. AI cenderung menguji jalur bahagia,
kecuali diminta secara eksplisit.

## 4. Perbaikan

Dikerjakan di sesi yang sama dengan T-005 karena keempatnya masih dalam DoD task ini
("server menghitung ulang harga", "stok tidak pernah minus"):

- Action hanya menerima `[{produkId, qty}]` dan `bayar`; field lain diabaikan.
- Validasi `qty` dan `bayar` sebagai bilangan bulat dalam rentang yang masuk akal.
- Pengurangan stok atomik → dicatat sebagai **DECISIONS 0004**.
- Test baru: harga palsu dari form diabaikan, qty negatif/0/desimal ditolak, dua penjualan bersamaan
  untuk stok terakhir → satu berhasil, satu ditolak.

```
make test  → 39 passed
make lint  → 0 problems
```

Review ulang di sesi baru: tidak ada temuan kritis/tinggi.

## 5. Selesai

- Centang T-005, pindahkan T-006 ke Aktif.
- Commit: `feat: simpan transaksi dengan validasi server dan stok atomik (T-005)`
- Pelajaran dicatat sebagai aturan baru di `AGENTS.md` proyek ini:
  *"Untuk setiap form action, tulis test dengan input jahat: field tambahan, angka negatif, dan peran yang salah."*
