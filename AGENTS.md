# AGENTS.md — Sumber Kebenaran untuk Semua AI Agent

> File ini dibaca langsung oleh Codex, Cursor, Copilot, Windsurf, Cline, Aider, Jules, dan agent lain.
> Claude Code dan Gemini CLI membacanya lewat baris import di `CLAUDE.md` dan `GEMINI.md`.
> **Edit HANYA file ini.** Jika kamu mengaktifkan salinan legacy (`.ai-sync-targets`), jalankan `make sync-ai` setelahnya.

<!-- TEMPLATE-NOTE:START — hapus blok ini setelah AGENTS.md diisi untuk proyekmu -->
> **Catatan template:** repo ini adalah *template*. Bagian `<...>` di bawah adalah placeholder yang harus
> diisi untuk proyekmu; sampai itu dilakukan, `make dev/test/lint/build` sengaja gagal.
> Urutan pengisiannya ada di `docs/ROADMAP.md` (PRD dulu, lalu arsitektur, baru `make init STACK=<nama>`).
> Jika kamu AI agent yang diminta mengembangkan template ini sendiri (bukan sebuah aplikasi), abaikan
> placeholder dan bagian "Arah & Tahap Proyek", lalu baca `README.md` serta `CONTRIBUTING.md`.
<!-- TEMPLATE-NOTE:END -->

## Project
- Nama: ai-app-boilerplate
- Tujuan: <1 kalimat: masalah apa, untuk siapa>
- Tahap: 0 — Ide (lihat `docs/ROADMAP.md`; perbarui setiap pindah tahap)

## Tech Stack
- Backend: <isi, mis. Laravel / Bun+Hono / FastAPI>
- Frontend: <isi, mis. React / Next.js>
- Database: <isi, mis. PostgreSQL>
- Test: <isi, mis. Pest / Vitest / Pytest>

## Perintah Penting
Semua perintah lewat `make` (isi implementasinya di `Makefile`, jaga agar tetap sinkron dengan bagian ini):
- Setup (hook + dependency): `make setup`
- Dev: `make dev`
- Test: `make test`
- Lint/format: `make lint`
- Build: `make build`
- Cek tahap proyek: `make status`
- Sync salinan legacy (hanya jika `.ai-sync-targets` aktif): `make sync-ai`

## Struktur Proyek
```
src/        kode aplikasi
tests/      test
docs/       ROADMAP, PRD, arsitektur, keputusan, daftar task
prompts/    template prompt reusable, berurutan sesuai tahap
examples/   contoh proyek yang sudah jadi (BUKAN spesifikasi proyek ini)
```

## Arah & Tahap Proyek
Proyek ini mengikuti tahapan di `docs/ROADMAP.md`. Sebelum mengerjakan permintaan apa pun, pastikan tahapnya cocok:
- Jika `docs/PRD.md` masih berisi placeholder `<...>`: **jangan menulis kode aplikasi.** Jelaskan bahwa PRD
  perlu diisi dulu dan arahkan ke `prompts/00-idea-to-prd.md`.
- Jika PRD sudah terisi tetapi `docs/ARCHITECTURE.md` belum: bantu desain arsitektur dulu (`prompts/02-design-architecture.md`).
- Jika arsitektur sudah ada tetapi `docs/TASKS.md` belum dipecah dari PRD: bantu memecah task dulu
  (`prompts/03-break-into-tasks.md`).
- Permintaan di luar task aktif: sampaikan, dan tawarkan untuk mencatatnya sebagai task baru di Backlog.
- Pengguna boleh secara eksplisit meminta melewati aturan ini (mis. untuk eksperimen); patuhi, tapi ingatkan sekali.
- Isi `examples/` hanyalah contoh. Jangan menganggapnya sebagai kebutuhan proyek ini.

Di akhir setiap jawaban yang menyelesaikan sesuatu, tulis satu baris **Langkah berikutnya** yang konkret
(prompt mana yang dipakai atau perintah apa yang dijalankan).

## Alur Kerja Wajib
1. Baca `docs/PRD.md`, `docs/ARCHITECTURE.md`, dan task aktif di `docs/TASKS.md` sebelum menulis kode.
2. Untuk perubahan non-trivial: **buat rencana dulu, tunggu persetujuan**, baru implementasi.
3. Kerjakan SATU task kecil per sesi. Jangan melebar ke luar scope task.
4. Tulis/update test untuk setiap perubahan perilaku.
5. Jalankan test + lint sebelum menyatakan selesai. Laporkan hasil sebenarnya, jangan mengarang.
6. Commit kecil dan sering dengan pesan jelas (Conventional Commits: `feat:`, `fix:`, `chore:`).
7. Catat keputusan arsitektur penting di `docs/DECISIONS.md`.
8. Setelah task selesai: centang di `docs/TASKS.md` dan perbarui dokumen di `docs/` yang tidak lagi sesuai dengan kode.

## Aturan Kode
- Ikuti konvensi yang sudah ada di repo; jangan memperkenalkan pola baru tanpa alasan.
- Fungsi kecil, nama jelas, tanpa kode mati atau komentar yang hanya mengulang kode.
- Jangan tambah dependency baru tanpa izin. Verifikasi paket benar-benar ada (jangan percaya nama hasil tebakan).
- Penanganan error eksplisit; jangan menelan error diam-diam.

## Keamanan (tidak boleh dilanggar)
- JANGAN hardcode secret, token, atau password. Pakai environment variable (`.env`, jangan di-commit).
- Validasi semua input dari luar (request, file, env).
- Query database selalu parameterized.
- Endpoint non-publik wajib melewati auth + otorisasi.
- Jangan log data sensitif (password, token, data pribadi).

## Batasan (minta izin dulu)
- Mengubah skema database / membuat migration destruktif
- Menghapus file atau data
- Mengubah CI/CD, konfigurasi deploy, atau file `.env*`
- Menambah dependency besar
- `git push --force`, rewrite history

## Jika Tidak Yakin
Bertanya lebih baik daripada menebak. Sebutkan asumsi secara eksplisit di jawaban.
Jika pengguna terlihat bingung harus ngapain, jalankan atau sarankan `make status` / `prompts/where-am-i.md`.
