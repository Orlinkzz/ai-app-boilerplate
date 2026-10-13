# Contoh: POS Warung

Contoh proyek kasir (point of sale) sederhana yang sudah melewati tahap 0-4 di
[`docs/ROADMAP.md`](../../docs/ROADMAP.md). Berbeda dengan [`kas-kelas`](../kas-kelas/), aplikasi ini
**memang butuh** backend, database, dan login, sehingga keputusan dan risikonya juga berbeda.

> Ini hanya contoh. AI agent tidak boleh menganggap isi folder ini sebagai kebutuhan proyekmu.
> Hapus folder `examples/` dari repo turunanmu jika tidak diperlukan.

## Ceritanya

Ide awal: *"bikin aplikasi kasir buat warung sembako saya, kayak aplikasi POS yang di minimarket."*

| Tahap | Apa yang terjadi | Hasil |
|---|---|---|
| 0. Ide | `00-idea-to-prd`: ternyata masalah terbesar pemilik bukan menghitung belanjaan, tapi **tidak tahu omzet harian dan stok yang hampir habis**, serta khawatir kasir salah input. | Draf PRD |
| 1. PRD | `01-review-prd` memotong 6 fitur "seperti minimarket": QRIS, printer struk, barcode, multi-cabang, member, laporan pajak. | [`PRD.md`](PRD.md) |
| 2. Arsitektur | `02-design-architecture`: React tanpa backend ditolak (data harus dibagi antar perangkat kasir dan pemilik). Dipilih SvelteKit + SQLite. | [`ARCHITECTURE.md`](ARCHITECTURE.md), [`DECISIONS.md`](DECISIONS.md) |
| 3. Setup & task | `make init STACK=svelte`, Vitest, CI hijau, lalu `03-break-into-tasks`. | [`TASKS.md`](TASKS.md) |
| 4. Bangun | Loop per task. Pada T-005 (simpan transaksi), review dan audit keamanan menemukan 3 bug serius. | [`SESI-T-005.md`](SESI-T-005.md) |

## Pelajaran dari contoh ini

- **"Seperti aplikasi X" bukan PRD.** Meniru POS minimarket berarti puluhan fitur. Wawancara di tahap 0
  menemukan bahwa pemilik warung hanya butuh 5 hal.
- **Kapan butuh backend?** Saat data harus dibagi antar orang/perangkat, atau saat ada aturan yang tidak boleh
  bisa diakali pengguna (harga, stok, hak akses). Di POS, keduanya berlaku.
- **Jangan percaya data dari browser.** Harga, total, dan hak akses selalu dihitung dan dicek di server.
  Ini temuan paling penting di [`SESI-T-005.md`](SESI-T-005.md), dan AI sempat melewatkannya saat implementasi.
- **Uang dan stok butuh test yang serius.** Satu bug pembulatan atau stok minus langsung berarti kerugian nyata.
- **Audit keamanan bukan hanya sebelum rilis.** Task yang menyentuh uang atau login langsung diaudit dengan
  `07-security-audit`, bukan menunggu akhir.
