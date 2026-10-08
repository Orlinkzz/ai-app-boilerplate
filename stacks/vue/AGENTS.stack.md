## Tech Stack
- Framework: Vue 3 (Composition API) + TypeScript, bundler Vite
- State global: Pinia; routing: Vue Router (opsional)
- Test: Vitest (`npm run test:unit`); lint: oxlint + ESLint; format: Prettier
- Scaffold awal: `npm create vue@latest` (pilih TypeScript, Vitest, ESLint, Prettier)

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
src/main.ts         entry point
src/App.vue         komponen akar
src/components/     komponen UI (+ __tests__/)
src/stores/         store Pinia
src/views/          halaman (jika pakai router)
vite.config.ts  tsconfig*.json
```

## Konvensi Stack
Stack: Vue 3 (Vite + TypeScript)
- Pakai `<script setup lang="ts">` dan Composition API; tipe props lewat `defineProps<...>()`.
- Hindari `v-html` pada data dari pengguna; jika terpaksa, sanitasi dulu.
- Variabel `VITE_*` terkirim ke browser: JANGAN taruh secret di sana.
- `npm run lint` bawaan scaffold memakai `--fix` (mengubah file); `make lint` memakai versi tanpa `--fix` untuk CI.
- Pindahkan logika bersama ke composable (`use*.ts`), bukan menyalin antar komponen.
