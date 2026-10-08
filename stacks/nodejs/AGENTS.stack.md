## Tech Stack
- Runtime: Node.js (LTS), package manager: npm (commit `package-lock.json`)
- Bahasa: TypeScript atau JavaScript (ESM)
- Server: Fastify atau Express
- Test: `node --test` atau Vitest
- Script wajib di `package.json`: `dev`, `test`, `lint`, `build`
- Scaffold awal: `npm init -y`, lalu tambahkan script di atas

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
src/index.ts        entry point
src/routes/         route/handler
src/services/       logika bisnis
src/config.ts       baca env sekali di sini
tests/              test
package.json  package-lock.json
```

## Konvensi Stack
Stack: Node.js (REST API)
- Baca konfigurasi dari environment di satu tempat (`src/config.ts`), jangan `process.env` tersebar.
- Validasi input request dengan skema; jangan percaya `req.body`.
- Satu penanganan error terpusat; jangan telan error diam-diam.
- Pakai `npm ci` (bukan `npm install`) di CI agar versi terkunci.
- Jangan log secret, token, atau data pribadi.
