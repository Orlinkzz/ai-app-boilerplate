## Tech Stack
- Runtime & package manager: Bun
- Bahasa: TypeScript (strict)
- Server: `Bun.serve` atau Hono
- Test: `bun test` (`bun:test`)
- Type-check: `tsc --noEmit` (pasang: `bun add -d typescript`)
- Scaffold awal: `bun init`, lalu buat `src/index.ts`

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
src/routes/         handler / route
src/lib/            util dan service
src/**/*.test.ts    test (bun:test), berdampingan dengan modul
package.json  tsconfig.json  bun.lock
```

## Konvensi Stack
Stack: Bun + TypeScript
- Pakai API bawaan Bun (`Bun.file`, `Bun.env`, `Bun.serve`) sebelum menambah dependency.
- TypeScript strict; hindari `any`.
- Validasi semua input request dengan skema (mis. Zod) di batas aplikasi.
- Commit `bun.lock`; jangan campur dengan lockfile npm/yarn/pnpm.
- Bun belum punya linter bawaan: `make lint` memakai type-check. Tambahkan Biome/ESLint bila perlu dan perbarui target `lint`.
