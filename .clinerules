<!-- GENERATED dari AGENTS.md oleh scripts/sync-ai-rules.sh. JANGAN EDIT LANGSUNG. -->

# AGENTS.md — Sumber Kebenaran untuk Semua AI Agent

> File ini dibaca oleh Claude Code, Codex, Cursor, Copilot, Gemini CLI, Windsurf, Cline, Aider, dan agent lain.
> **Edit HANYA file ini**, lalu jalankan `make sync-ai`. Jangan edit hasil generate-nya.

## Project
- Nama: ai-app-boilerplate
- Tujuan: <1 kalimat: masalah apa, untuk siapa>
- Status: MVP

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
- Sync file rules AI setelah mengubah file ini: `make sync-ai`

## Struktur Proyek
```
src/        kode aplikasi
tests/      test
docs/       PRD, arsitektur, keputusan, daftar task
prompts/    template prompt reusable
```

## Alur Kerja Wajib
1. Baca `docs/PRD.md`, `docs/ARCHITECTURE.md`, dan task aktif di `docs/TASKS.md` sebelum menulis kode.
2. Untuk perubahan non-trivial: **buat rencana dulu, tunggu persetujuan**, baru implementasi.
3. Kerjakan SATU task kecil per sesi. Jangan melebar ke luar scope task.
4. Tulis/update test untuk setiap perubahan perilaku.
5. Jalankan test + lint sebelum menyatakan selesai. Laporkan hasil sebenarnya, jangan mengarang.
6. Commit kecil dan sering dengan pesan jelas (Conventional Commits: `feat:`, `fix:`, `chore:`).
7. Catat keputusan arsitektur penting di `docs/DECISIONS.md`.

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
