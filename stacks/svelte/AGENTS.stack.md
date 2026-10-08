## Tech Stack
- Framework: SvelteKit (Svelte 5) + TypeScript, bundler Vite
- Type-check: `svelte-check` (`npm run check`)
- Test: Vitest (belum termasuk scaffold, tambahkan di task pertama)
- Scaffold awal: `npx sv create .` (pilih TypeScript)
- Tambah test: `npm i -D vitest`, lalu script `"test": "vitest"`

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
src/routes/         halaman (+page.svelte, +page.server.ts, +server.ts)
src/lib/            komponen dan util bersama
src/lib/server/     kode khusus server (tidak terkirim ke browser)
static/             aset statis
svelte.config.js  vite.config.ts
```

## Konvensi Stack
Stack: SvelteKit (TypeScript)
- Pakai runes Svelte 5 (`$state`, `$derived`, `$props`) pada kode baru.
- Data server dimuat di `+page.server.ts`/`+layout.server.ts`; mutasi lewat form actions.
- Secret hanya via `$env/static/private` di file server; variabel publik berawalan `PUBLIC_`.
- Hindari `{@html ...}` untuk data pengguna.
- Bawaan scaffold belum punya linter: `make lint` memakai `svelte-check`. Tambahkan ESLint (`npx sv add eslint`) bila perlu dan perbarui target `lint`.
