## Tech Stack
- Backend: Laravel (PHP), REST API dengan Sanctum untuk auth
- Frontend: React (Vite) di `resources/js/`
- Database: PostgreSQL (MySQL juga bisa)
- Test: Pest/PHPUnit (backend), Vitest (frontend)
- Scaffold awal: `composer create-project laravel/laravel .`, lalu pasang React/Vite sesuai kebutuhan

## Perintah Penting
Semua perintah lewat `make` (implementasinya di `Makefile`, jaga agar tetap sinkron dengan bagian ini):
- Setup (hook + dependency): `make setup`
- Install dependency saja: `make deps`
- Dev: `make dev`
- Test: `make test`
- Lint/format check: `make lint`
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
```

## Konvensi Stack
Stack: Laravel + React
- Validasi selalu lewat Form Request, jangan di controller.
- Otorisasi lewat Policy/Gate; jangan hanya mengandalkan menyembunyikan tombol di UI.
- Pakai API Resource untuk bentuk respons; jangan mengembalikan model mentah.
- Lindungi dari mass assignment: definisikan `$fillable`, hindari `$guarded = []`.
- Hindari N+1: gunakan eager loading (`with()`), tambahkan test untuk endpoint list.
- Jangan edit migration yang sudah dijalankan; buat migration baru.
- React: komponen fungsional + hooks; state server lewat satu pustaka (mis. TanStack Query).
- Jangan simpan token di `localStorage` tanpa pertimbangan keamanan yang dicatat di `docs/DECISIONS.md`.
