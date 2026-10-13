# Template Stack

Pilih stack, lalu terapkan ke `AGENTS.md`, `Makefile`, dan CI dalam satu perintah:

```bash
make stacks              # daftar stack
make init STACK=react    # terapkan
bash scripts/init-stack.sh react --dry-run   # lihat perubahan tanpa menulis apa pun
```

Yang diubah oleh `make init`:

| File | Perubahan |
|---|---|
| `AGENTS.md` | Bagian *Tech Stack*, *Perintah Penting*, *Struktur Proyek* diganti; *Konvensi Stack* ditambahkan |
| `Makefile` | Target `deps`, `dev`, `test`, `lint`, `build` terisi (di antara marker `STACK-TARGETS`) |
| `.github/workflows/ci.yml` | Setup runtime + `make deps` (di antara marker `STACK-SETUP`) |

Aman dijalankan ulang (hasilnya sama) dan bisa dipakai untuk berganti stack. Setelah itu buat proyeknya
sesuai bagian *Scaffold awal* di `AGENTS.md` (template ini tidak membuatkan kode aplikasi).

## Memilih stack

Pilih stack **setelah** PRD selesai (lihat `docs/ROADMAP.md`, tahap 2). `prompts/02-design-architecture.md`
akan merekomendasikan stack berdasarkan PRD; tabel ini membantu kamu menilai rekomendasinya.

| Mau bikin apa | Stack yang cocok | Kenapa |
|---|---|---|
| Situs/aplikasi web interaktif, data cukup di browser atau layanan pihak ketiga | `react`, `vue`, atau `svelte` | Hanya frontend, paling mudah di-hosting gratis |
| Web dengan halaman + backend dalam satu proyek (form, login, database) | `svelte` (SvelteKit) | Satu framework untuk halaman dan server |
| API/backend saja, atau bot (mis. bot WhatsApp/Telegram) | `nodejs`, `bun`, atau `go` | Ringan; Go paling hemat resource, Node.js paling banyak contoh |
| Aplikasi bisnis dengan banyak form, CRUD, dan role pengguna | `laravel-react` | Laravel menyediakan auth, migration, validasi siap pakai (template ini **belum diuji**) |

Aturan praktis:
- Sudah menguasai salah satunya? **Pakai yang sudah kamu kuasai.** Kamu harus bisa membaca dan me-review kode dari AI.
- Belum menguasai apa pun dan ini proyek web? Mulai dari `react` atau `svelte`: contoh dan bantuan AI paling banyak.
- Ragu antara frontend saja atau perlu backend? Tanyakan: apakah data harus tersimpan dan dibagi antar pengguna?
  Jika ya, kamu butuh backend + database.

### Tempat hosting (tahap 5)

Gambaran umum saja. Harga, batas paket gratis, dan fiturnya sering berubah; selalu cek situs resminya
dan pakai `prompts/09-deploy.md` untuk memilih.

| Stack | Jenis hosting yang cocok |
|---|---|
| `react`, `vue` | Hosting situs statis (mis. GitHub Pages, Netlify, Vercel, Cloudflare Pages) |
| `svelte` | Hosting statis jika tanpa server; platform dengan adapter SvelteKit jika memakai fitur server |
| `nodejs`, `bun`, `go` | Platform aplikasi/container (PaaS) atau VPS |
| `laravel-react` | Hosting PHP, PaaS yang mendukung PHP, atau VPS |

## Stack yang tersedia

| Stack | Scaffold awal | `make lint` menjalankan | Status uji |
|---|---|---|---|
| `bun` | `bun init` | `tsc --noEmit` (Bun belum punya linter) | e2e lolos |
| `nodejs` | `npm init -y` | `npm run lint` (script milikmu) | e2e lolos* |
| `react` | `npm create vite@latest . -- --template react-ts` | `npm run lint` (oxlint di scaffold saat ini) | e2e lolos |
| `vue` | `npm create vue@latest` (TS, Vitest, ESLint, Prettier) | type-check + oxlint + ESLint tanpa `--fix` | e2e lolos |
| `svelte` | `npx sv create .` (SvelteKit, TS) | `svelte-check` | e2e lolos |
| `go` | `go mod init` + `cmd/app/main.go` | `go vet` + cek `gofmt` | e2e lolos |
| `laravel-react` | `composer create-project laravel/laravel .` | Pint + `npm run lint` | **belum diuji** (butuh PHP) |

\* Untuk `nodejs`, e2e memakai proyek minimal dengan script buatan sendiri, jadi yang teruji terutama kabel
`Makefile` dan CI, bukan framework tertentu.

"e2e lolos" artinya: proyek nyata dibuat dengan scaffold resmi, template diterapkan, lalu `make deps`, `lint`,
`test`, `build` (dan `dev` yang mulai berjalan) sukses. Dijalankan lewat `bash tests/e2e-stacks.sh`
dengan Node 22 + npm 12, Bun 1.4, dan Go 1.22 (Oktober 2026). Tes ini manual, tidak jalan di CI.

## Catatan per stack

- **react, svelte**: scaffold resminya belum menyertakan test runner. Tambahkan Vitest di task pertama
  (`npm i -D vitest` dan script `"test": "vitest"`). Sampai itu dilakukan, `make test` gagal, itu disengaja.
- **vue**: script `lint` bawaan `create-vue` memakai `--fix` (mengubah file), jadi `make lint` memakai perintah tanpa `--fix`.
- **bun**: pasang TypeScript dengan `bun add -d typescript` agar `make lint` jalan.
- **CI**: `setup-node` memakai `cache: npm`, yang butuh `package-lock.json` ter-commit.
- Jika `npm install` gagal dengan `Cannot read properties of null (reading 'edgesOut')`, perbarui npm
  (`npm i -g npm@latest`). Ini terjadi di npm 10.9 saat kami menguji, bukan karena template.

## Menambah stack baru

Buat `stacks/<nama>/` (huruf kecil, angka, `-`) berisi tiga file:

- `AGENTS.stack.md`: empat bagian `## Tech Stack`, `## Perintah Penting`, `## Struktur Proyek`, `## Konvensi Stack`
- `Makefile.stack`: target `deps`, `dev`, `test`, `lint`, `build` (recipe diawali **tab**)
- `ci-setup.yml`: langkah CI dengan indentasi 6 spasi, diakhiri `- run: make deps`

Lalu jalankan `make selftest`. Tes akan memeriksa kelengkapan template baru secara otomatis.
