# Contoh Proyek

Contoh proyek yang sudah melewati tahap di [`docs/ROADMAP.md`](../docs/ROADMAP.md). Isinya dokumen
(PRD, arsitektur, keputusan, task, dan ringkasan satu sesi kerja dengan AI), **bukan** kode aplikasi.
Pakai sebagai gambaran seperti apa isian yang baik, lalu tulis versimu sendiri di `docs/`.

> AI agent: isi folder ini hanyalah contoh, bukan kebutuhan proyek yang sedang dikerjakan.

| Contoh | Pengguna | Stack | Yang bisa dipelajari |
|---|---|---|---|
| [`kas-kelas`](kas-kelas/) | 1 bendahara, 1 HP | `react`, tanpa backend | Memotong scope; tidak semua aplikasi butuh server, login, dan database |
| [`pos-warung`](pos-warung/) | Pemilik + 2 kasir | `svelte` + SQLite | Kapan butuh backend; aturan uang, stok, dan hak akses di server; audit keamanan menangkap bug yang lolos test |

Cara membaca: mulai dari `README.md` tiap contoh, lalu `PRD.md` → `ARCHITECTURE.md` → `DECISIONS.md` →
`TASKS.md` → file `SESI-*.md`.

Hapus folder `examples/` dari repo turunanmu jika tidak diperlukan.
