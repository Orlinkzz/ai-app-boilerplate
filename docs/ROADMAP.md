# Peta Jalan: dari Ide sampai Aplikasi Dipakai Orang

Bingung harus ngapain? Jalankan `make status`, atau tempel `prompts/where-am-i.md` ke AI.
Keduanya memberi tahu kamu sedang di tahap mana dan langkah berikutnya.

Aturan utamanya: **jangan lompat tahap**. AI sangat cepat menulis kode, jadi godaan terbesar adalah langsung
coding. Tanpa PRD dan arsitektur, AI akan menebak, dan tebakannya berubah-ubah tiap sesi.

| Tahap | Tujuan | Prompt | Hasil (file) | Selesai jika |
|---|---|---|---|---|
| 0. Ide | Tahu masalah apa dan untuk siapa | `00-idea-to-prd` | draf `docs/PRD.md` | Bisa dijelaskan dalam 2 kalimat |
| 1. PRD | Scope MVP jelas dan kecil | `01-review-prd` | `docs/PRD.md` final | Lolos review, scope MVP ≤ 5 fitur |
| 2. Arsitektur | Stack dan desain dipilih | `02-design-architecture` | `docs/ARCHITECTURE.md`, `docs/DECISIONS.md` | Stack dipilih beserta alasannya |
| 3. Setup & task | Proyek bisa dites, pekerjaan terpecah | `03-break-into-tasks` | `make init`, `docs/TASKS.md` | T-001 selesai: `make lint` + `make test` hijau di CI |
| 4. Bangun MVP | Mengerjakan task satu per satu | `04` → `05` → `06` (+ `07`) | kode + test | Semua task MVP dicentang |
| 5. Rilis | Aplikasi bisa dipakai orang lain | `07-security-audit`, `09-deploy` | aplikasi online | Orang lain bisa membukanya |
| 6. Iterasi | Belajar dari pengguna | `10-iterate` | PRD versi baru, task baru | Kembali ke tahap 4 |

`08-debug` dipakai kapan saja ada bug.

## Tahap 0 — Ide

**Input:** ide kasar, boleh satu kalimat.
**Cara:** tempel `prompts/00-idea-to-prd.md` ke AI. AI akan mewawancaraimu satu pertanyaan per giliran.
**Hasil:** draf `docs/PRD.md`.

Tanda kamu belum siap lanjut: kamu belum bisa menyebut *satu* kelompok pengguna yang spesifik, atau
masalahnya masih "biar lebih mudah" tanpa contoh nyata.

## Tahap 1 — PRD

**Cara:** tempel `prompts/01-review-prd.md` di sesi AI **baru** (supaya AI tidak membela tulisannya sendiri).
Revisi PRD sampai AI menilai "siap lanjut".
**Selesai jika:** semua placeholder `<...>` di `docs/PRD.md` sudah terisi, scope MVP maksimal 5 fitur,
dan bagian "TIDAK masuk" tidak kosong.

Memotong fitur adalah keputusan terpenting di tahap ini. MVP yang kecil dan selesai lebih berguna
daripada MVP besar yang berhenti di tengah jalan.

## Tahap 2 — Arsitektur

**Cara:** `prompts/02-design-architecture.md`. Sebutkan bahasa yang sudah kamu kuasai dan budget hosting.
**Hasil:** `docs/ARCHITECTURE.md` terisi, satu entri di `docs/DECISIONS.md` untuk pilihan stack.

Belum tahu harus pilih stack apa? Lihat tabel "Memilih stack" di `stacks/README.md`.
Prinsipnya: pilih yang paling sederhana yang cukup untuk PRD, bukan yang paling populer.

## Tahap 3 — Setup dan pecah task

1. Terapkan stack: `make init STACK=<nama>` (lihat `make stacks`).
2. Isi Nama dan Tujuan di `AGENTS.md`, lalu hapus blok `TEMPLATE-NOTE`.
3. `make setup`, lalu buat proyeknya sesuai bagian *Scaffold awal* di `AGENTS.md`.
4. Kerjakan T-001 sampai `make lint` dan `make test` hijau, lokal dan di CI.
5. Pecah PRD jadi task dengan `prompts/03-break-into-tasks.md`.

> **CI merah di awal itu normal.** Target `test`/`lint` sengaja gagal sampai diisi, supaya CI tidak
> hijau palsu. Membuatnya hijau adalah task pertamamu (T-001).

## Tahap 4 — Bangun MVP (loop per task)

Untuk setiap task di `docs/TASKS.md`:

1. `04-plan-task`: AI membuat rencana. **Baca dan setujui dulu**; tolak jika melebar dari task.
2. `05-implement-task`: AI menulis kode + test, lalu menjalankan `make test` dan `make lint`.
3. `06-review-code` di sesi baru. Tambah `07-security-audit` jika task menyentuh login, input user,
   upload, atau data pribadi.
4. Centang task, commit kecil, pindahkan task berikutnya ke bagian Aktif.

Satu task = satu sesi AI = satu commit. Jika sesi AI mulai "lupa" atau melantur, tutup dan mulai sesi baru;
semua konteks penting sudah ada di `AGENTS.md` dan `docs/`.

## Tahap 5 — Rilis

1. Jalankan `prompts/07-security-audit.md` untuk seluruh aplikasi, perbaiki temuan yang kritis/tinggi.
2. `prompts/09-deploy.md`: pilih hosting dan ikuti checklist deploy-nya.
3. Minta minimal satu orang lain mencoba aplikasinya.

## Tahap 6 — Iterasi

Kumpulkan masukan pengguna, lalu `prompts/10-iterate.md`. Hasilnya PRD versi baru dan task baru;
kembali ke tahap 4.

## Tanda kamu tersesat

- Sudah menulis banyak kode, tapi `docs/PRD.md` masih kosong → kembali ke tahap 0/1.
- Satu sesi AI mengubah lebih dari ~10 file → task terlalu besar, pecah lagi.
- Sudah lama tidak commit → commit yang sudah jalan, buang sisanya.
- AI terus menambah fitur yang tidak diminta → ingatkan scope task, atau mulai sesi baru.
- Tidak tahu kenapa kodenya bekerja → minta AI menjelaskan sebelum lanjut. Kamu yang bertanggung jawab atas kode itu.

Contoh proyek yang sudah melewati tahap 0-4 ada di [`examples/kas-kelas/`](../examples/kas-kelas/).
