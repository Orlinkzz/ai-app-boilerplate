# AGENTS.md — Contoh terisi: Laravel + React

> Ini hanya CONTOH pengisian (disalin dari template lalu disesuaikan).
> File ini dibaca langsung oleh Codex, Cursor, Copilot, Windsurf, Cline, Aider, Jules, dan agent lain.
> Claude Code dan Gemini CLI membacanya lewat baris import di `CLAUDE.md` dan `GEMINI.md`.
> **Edit HANYA file ini.** Jika kamu mengaktifkan salinan legacy (`.ai-sync-targets`), jalankan `make sync-ai` setelahnya.

## Project
- Nama: Contoh Aplikasi Inventaris
- Tujuan: membantu tim toko kecil mencatat stok barang dan melihat barang yang hampir habis
- Status: MVP

## Tech Stack
- Backend: Laravel (PHP), REST API dengan Sanctum untuk auth
- Frontend: React (Vite) di `resources/js/`
- Database: PostgreSQL (MySQL juga bisa)
- Test: Pest/PHPUnit (backend), Vitest (frontend)

## Perintah Penting
Semua perintah lewat `make` (lihat `Makefile.example` untuk isinya):
- Setup (hook + dependency): `make setup`
- Dev: `make dev`
- Test: `make test`
- Lint/format: `make lint`
- Build: `make build`
- Sync salinan legacy (hanya jika `.ai-sync-targets` aktif): `make sync-ai`

## Struktur Proyek
```
app/Http/Controllers/   controller tipis, logika di service/action
app/Http/Requests/      validasi (Form Request)
app/Models/             model Eloquent
app/Policies/           otorisasi
routes/api.php          endpoint API
resources/js/           aplikasi React
tests/                  Feature & Unit test
docs/                   PRD, arsitektur, keputusan, daftar task
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

## Konvensi Laravel + React
- Validasi selalu lewat Form Request, jangan di controller.
- Otorisasi lewat Policy/Gate; jangan hanya mengandalkan sembunyi tombol di UI.
- Pakai API Resource untuk bentuk respons; jangan mengembalikan model mentah.
- Lindungi dari mass assignment: definisikan `$fillable`, hindari `$guarded = []`.
- Query N+1: gunakan eager loading (`with()`), tambahkan test untuk endpoint list.
- Migration: jangan edit migration yang sudah dijalankan; buat migration baru.
- React: komponen fungsional + hooks, state server lewat satu pustaka (mis. TanStack Query), bukan `useEffect` + `fetch` berulang.
- Jangan simpan token di `localStorage` tanpa pertimbangan keamanan yang dicatat di `docs/DECISIONS.md`.
