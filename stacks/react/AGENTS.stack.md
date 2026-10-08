## Tech Stack
- Framework: React + TypeScript, bundler Vite
- Lint: sesuai scaffold Vite (`npm run lint`)
- Test: Vitest + Testing Library (belum termasuk scaffold Vite, tambahkan di task pertama)
- Scaffold awal: `npm create vite@latest . -- --template react-ts`
- Tambah test: `npm i -D vitest @testing-library/react jsdom`, lalu script `"test": "vitest"`

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
src/main.tsx        entry point
src/App.tsx         komponen akar
src/components/     komponen UI
src/hooks/          custom hooks
src/lib/            util dan klien API
src/**/*.test.tsx   test komponen
index.html  vite.config.ts
```

## Konvensi Stack
Stack: React (Vite + TypeScript)
- Komponen fungsional + hooks; tipe props eksplisit, hindari `any`.
- State server lewat satu pustaka (mis. TanStack Query), bukan `useEffect` + `fetch` berulang.
- Variabel `VITE_*` terkirim ke browser: JANGAN taruh secret di sana.
- Hindari `dangerouslySetInnerHTML`; jika terpaksa, sanitasi dulu.
- Test perilaku lewat Testing Library (query by role/label), bukan detail implementasi.
