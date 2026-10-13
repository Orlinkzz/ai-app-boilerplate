# Contoh: Kas Kelas

Contoh proyek kecil yang sudah melewati tahap 0-4 di [`docs/ROADMAP.md`](../../docs/ROADMAP.md).
Tujuannya menunjukkan **seperti apa isian yang baik** di tiap tahap, bukan memberi kode jadi.

> Ini hanya contoh. AI agent tidak boleh menganggap isi folder ini sebagai kebutuhan proyekmu.
> Hapus folder `examples/` dari repo turunanmu jika tidak diperlukan.

## Ceritanya

Ide awal (satu kalimat, berantakan): *"aplikasi buat bendahara kelas biar gampang catat uang kas."*

| Tahap | Apa yang terjadi | Hasil |
|---|---|---|
| 0. Ide | `00-idea-to-prd`: AI bertanya 7 pertanyaan. Ternyata masalah utamanya bukan *mencatat*, tapi *tahu siapa yang belum bayar*. | Draf PRD |
| 1. PRD | `01-review-prd` di sesi baru memotong 3 fitur (laporan PDF, notifikasi WhatsApp, multi-kelas). | [`PRD.md`](PRD.md) |
| 2. Arsitektur | `02-design-architecture` menawarkan React (tanpa backend) vs SvelteKit + database. Dipilih React karena hanya satu pengguna. | [`ARCHITECTURE.md`](ARCHITECTURE.md), [`DECISIONS.md`](DECISIONS.md) |
| 3. Setup & task | `make init STACK=react`, T-001 sampai CI hijau, lalu `03-break-into-tasks`. | [`TASKS.md`](TASKS.md) |
| 4. Bangun | Loop plan → implement → review per task. | Contoh satu putaran: [`SESI-T-003.md`](SESI-T-003.md) |

## Pelajaran dari contoh ini

- **Fitur terpenting baru ketahuan saat diwawancarai.** Tanpa tahap 0, aplikasi ini akan fokus ke form input,
  padahal yang dibutuhkan bendahara adalah daftar tunggakan.
- **Memotong fitur adalah kemajuan.** Tiga fitur yang dipotong masuk "TIDAK masuk" dan bisa jadi iterasi berikutnya.
- **Tidak semua aplikasi butuh login dan database.** Keputusan ini dicatat di `DECISIONS.md` beserta
  konsekuensinya (data hanya di satu perangkat), sehingga tidak dipertanyakan ulang tiap sesi AI.
- **Task vertikal.** T-002 langsung menghasilkan sesuatu yang bisa dicoba, bukan "buat semua komponen dulu".
