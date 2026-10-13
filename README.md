# AI App Boilerplate

[![CI](https://github.com/Orlinkzz/ai-app-boilerplate/actions/workflows/ci.yml/badge.svg)](https://github.com/Orlinkzz/ai-app-boilerplate/actions/workflows/ci.yml)

> *From idea to app, with any AI coding tool.* A template and step-by-step roadmap for building apps with AI
> (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Windsurf, Cline, Aider). Documentation is in Indonesian.

Punya ide aplikasi dan mau membuatnya dengan bantuan AI, tapi **bingung harus mulai dari mana dan arahnya ke mana?**
Template ini memberimu:

- **Peta jalan** dari ide sampai aplikasi dipakai orang, dengan tanda "selesai" di tiap tahap ([`docs/ROADMAP.md`](docs/ROADMAP.md))
- **Prompt siap pakai** untuk tiap tahap, bisa dipakai di AI mana pun ([`prompts/`](prompts/))
- **Aturan untuk AI** dalam satu file (`AGENTS.md`) yang dibaca banyak tool, termasuk aturan agar AI tidak langsung coding sebelum arahnya jelas
- **`make status`**: kapan pun bingung, perintah ini memberi tahu kamu sedang di tahap mana dan langkah berikutnya
- **Contoh proyek** yang sudah melewati tahap 0-4 ([`examples/`](examples/)): aplikasi kas kelas tanpa backend, dan aplikasi kasir (POS) warung dengan login dan database
- **Template stack** (React, Vue, Svelte, Node.js, Bun, Go, Laravel) plus git hook dan CI yang menjaga proyek tetap rapi

**Tutorial lengkap online:** https://orlinkzz.github.io/ai-app-boilerplate/

## Peta Jalan

| Tahap | Kamu melakukan | Prompt | Selesai jika |
|---|---|---|---|
| 0. Ide | Diwawancarai AI tentang idemu | [`00-idea-to-prd`](prompts/00-idea-to-prd.md) | Masalah & pengguna bisa dijelaskan dalam 2 kalimat |
| 1. PRD | Mengkritik dan memotong scope | [`01-review-prd`](prompts/01-review-prd.md) | Scope MVP ≤ 5 fitur |
| 2. Arsitektur | Memilih stack dan desain | [`02-design-architecture`](prompts/02-design-architecture.md) | Stack dipilih beserta alasannya |
| 3. Setup & task | `make init`, pecah PRD jadi task | [`03-break-into-tasks`](prompts/03-break-into-tasks.md) | CI hijau, `docs/TASKS.md` terisi |
| 4. Bangun MVP | Loop per task: rencana → kode → review | [`04`](prompts/04-plan-task.md) → [`05`](prompts/05-implement-task.md) → [`06`](prompts/06-review-code.md) (+ [`07`](prompts/07-security-audit.md)) | Semua task MVP selesai |
| 5. Rilis | Audit keamanan, deploy | [`07-security-audit`](prompts/07-security-audit.md), [`09-deploy`](prompts/09-deploy.md) | Orang lain bisa memakainya |
| 6. Iterasi | Olah masukan pengguna | [`10-iterate`](prompts/10-iterate.md) | Kembali ke tahap 4 |

Ada bug? [`08-debug`](prompts/08-debug.md). Tersesat? `make status` atau [`where-am-i`](prompts/where-am-i.md).
Penjelasan tiap tahap ada di [`docs/ROADMAP.md`](docs/ROADMAP.md).

## Mulai Cepat

**Prasyarat:** `git`, `make`, `bash`, dan satu AI coding tool. Di Windows, pakai **WSL** atau **Git Bash**
(lihat [Pengguna Windows](#pengguna-windows)).

**1. Buat repo dari template.** Klik **Use this template** di halaman GitHub repo ini, lalu clone repo barumu:

```bash
git clone https://github.com/<akun-kamu>/<nama-app>.git && cd <nama-app>
```

<details>
<summary>Tanpa akun GitHub / tanpa tombol template</summary>

```bash
git clone --depth 1 https://github.com/Orlinkzz/ai-app-boilerplate.git nama-app
cd nama-app
rm -rf .git && git init -b main   # buang riwayat template, mulai riwayat baru milikmu
```
</details>

**2. Aktifkan git hook dan cek posisimu:**

```bash
make setup
make status
```

**3. Ikuti peta jalan.** Buka AI tool pilihanmu di folder ini, salin isi `prompts/00-idea-to-prd.md`, dan mulai.
Stack baru dipilih di tahap 2, setelah jelas aplikasinya butuh apa. Lalu terapkan dengan
`make init STACK=<nama>` (lihat `make stacks` dan [`stacks/README.md`](stacks/README.md)).

> **CI merah dan `make test` gagal di awal itu normal.** Target test/lint sengaja gagal sampai stack diterapkan,
> supaya CI tidak hijau palsu. Membuatnya hijau adalah task pertamamu (T-001 di `docs/TASKS.md`).

## Isi Repo

| Path | Isi |
|---|---|
| `AGENTS.md` | Aturan untuk semua AI agent. Satu-satunya file aturan yang perlu kamu edit |
| `CLAUDE.md`, `GEMINI.md`, `.aider.conf.yml` | Penghubung ke `AGENTS.md` untuk Claude Code, Gemini CLI, Aider |
| `docs/` | `ROADMAP` (peta tahap), `PRD`, `ARCHITECTURE`, `TASKS`, `DECISIONS` |
| `prompts/` | Prompt bernomor sesuai tahap |
| `examples/` | Contoh proyek yang sudah jadi. Hapus dari repo turunanmu jika tidak perlu |
| `stacks/` | Template stack untuk `make init` |
| `.claude/commands/` | Perintah singkat Claude Code: `/plan`, `/review`, `/status` |

## Tool yang Ditargetkan

| Tool | Cara membaca instruksi | Di repo ini |
|---|---|---|
| Codex, Jules, Cursor, Windsurf, Cline, GitHub Copilot | membaca `AGENTS.md` langsung (bergantung versi) | tidak perlu file tambahan |
| Claude Code | hanya membaca `CLAUDE.md` | `CLAUDE.md` berisi `@AGENTS.md` |
| Gemini CLI | membaca `GEMINI.md` | `GEMINI.md` berisi `@./AGENTS.md` |
| Aider | konfigurasi `read:` | `.aider.conf.yml` merujuk ke `AGENTS.md` |

> Tabel ini disusun dari dokumentasi tiap tool dan **belum diuji langsung di semua tool**.
> Jika ada yang tidak bekerja, buka issue.

Prompt di `prompts/` juga bisa dipakai di AI chat biasa (cukup copy-paste), tapi AI agent yang bisa membaca
file proyek akan memberi hasil yang jauh lebih baik.

## Prinsip

- Kamu arsitek, AI eksekutor. Kamu yang memutuskan arah; AI mempercepat pengerjaannya.
- Jangan lompat tahap. Kode tanpa PRD membuat AI menebak, dan tebakannya berubah tiap sesi.
- Task kecil, commit sering, test selalu.
- Kode yang jalan belum tentu benar atau aman. Baca dan review sendiri.

---

## Untuk Pengguna Lanjut

### Perintah `make`

| Perintah | Fungsi |
|---|---|
| `make status` | Tebak tahap proyek dari isi `docs/` dan `Makefile`, sarankan langkah berikutnya |
| `make setup` | Aktifkan git hook, lalu `make deps` |
| `make deps` | Install dependency (terisi oleh `make init`) |
| `make stacks` / `make init STACK=<nama>` | Daftar / terapkan template stack |
| `make dev` / `test` / `lint` / `build` | Placeholder. **Sengaja gagal** sampai kamu isi (atau `make init`), agar CI tidak hijau palsu |
| `make sync-ai` | Perbarui salinan legacy yang aktif di `.ai-sync-targets` (dan buat stub yang hilang) |
| `make check-ai` | Verifikasi stub `CLAUDE.md`/`GEMINI.md` dan salinan legacy aktif (mendeteksi usang dan hilang) |
| `make selftest` | Tes mandiri script sync, hook, stack, dan status (untuk maintainer template) |

`make status` memakai heuristik sederhana: baris yang masih berisi placeholder `<...>` dianggap belum diisi.
Untuk penilaian yang lebih teliti, pakai `prompts/where-am-i.md`.

### Template Stack

Tersedia: **bun, nodejs, react, vue, svelte, go, laravel-react**. `make init STACK=<nama>` mengisi `AGENTS.md`,
target `Makefile`, dan setup CI sekaligus. Panduan memilih stack, saran hosting, status uji, dan cara menambah
stack ada di [`stacks/README.md`](stacks/README.md). Enam stack pertama sudah diuji end-to-end dengan toolchain
asli; `laravel-react` belum.

Tanpa stack yang cocok: isi sendiri target `deps/dev/test/lint/build` di `Makefile` dan bagian
*Tech Stack*/*Perintah Penting* di `AGENTS.md`.

### Pengaman Otomatis

**Pre-commit hook** (aktif setelah `make setup`):
1. Menolak commit file `.env` / `.env.*` (kecuali `.env.example`)
2. Jika `AGENTS.md` ikut di-commit dan ada salinan legacy aktif, otomatis sync dan stage salinannya
3. Menolak commit jika stub tidak valid atau salinan legacy usang

**CI** (`.github/workflows/ci.yml`), tiga job:
- `ai-rules`: `make check-ai`
- `selftest`: ShellCheck + `make selftest`. **Hanya jalan di repo template ini**, bukan di repo turunan.
- `quality`: `make lint` dan `make test`. Merah sampai kamu menerapkan stack dan menyelesaikan T-001;
  `make init` mengisi setup runtime-nya otomatis. **Hanya jalan di repo turunan.**

Hook bisa dilewati dengan `git commit --no-verify`, tapi CI tetap menangkapnya.

### Salinan Legacy (opsional)

Versi tool yang lebih lama mungkin belum membaca `AGENTS.md`. Untuk itu `.ai-sync-targets` menyediakan daftar
salinan opsional, **semuanya nonaktif secara default**: `.cursor/rules/project.mdc`,
`.github/copilot-instructions.md`, `.windsurfrules`, dan `.clinerules`.

Aktifkan dengan menghapus tanda `#` di barisnya, lalu jalankan `make sync-ai`. Catatan dari dokumentasi tool
(dicek Oktober 2026; konvensi bisa berubah):

- Windsurf kini memakai `.windsurf/rules/*.md`; `.windsurfrules` adalah format lama.
- Cline merekomendasikan folder `.clinerules/`; jika `.clinerules` ada, ia diprioritaskan di atas `AGENTS.md`.
- Di tool yang sudah membaca `AGENTS.md`, salinan bisa membuat instruksi yang sama termuat dua kali.

### Menambah Tool Baru

Tool yang sudah membaca `AGENTS.md` tidak perlu apa-apa. Jika butuh file sendiri, tambahkan sebagai baris
dikomentari di `.ai-sync-targets`. Untuk format khusus (mis. frontmatter), ubah fungsi `render()` di
`scripts/sync-ai-rules.sh` dan tambahkan skenario tes di `tests/test-sync.sh`.

### Situs Dokumentasi

Folder `site/` berisi halaman tutorial statis (HTML murni, tanpa build) yang diterbitkan ke GitHub Pages oleh
`.github/workflows/pages.yml`. Aktifkan di Settings → Pages → Source: **GitHub Actions**. Workflow-nya hanya jalan di
repo template ini. Di repo turunan, hapus `site/` dan `pages.yml` jika tidak dipakai.

### Pengguna Windows

`make` dan script bash tidak jalan di PowerShell atau CMD biasa. Pilih salah satu:

- **WSL (disarankan):** jalankan `wsl --install` di PowerShell sebagai Administrator, restart, lalu buka
  terminal Ubuntu dan pasang alatnya: `sudo apt update && sudo apt install -y git make`.
  Simpan proyek di dalam sistem file Linux (mis. `~/proyek`), bukan di `/mnt/c/...`, agar cepat.
- **Git Bash:** sudah terpasang bersama Git for Windows, tapi belum menyertakan `make`;
  pasang terpisah (mis. lewat `winget` atau Chocolatey).

Izin eksekusi script bisa hilang saat commit dari Windows; lihat [CONTRIBUTING.md](CONTRIBUTING.md#pengguna-windows).

### Catatan

- Versi action di CI (`actions/checkout`) perlu diperbarui berkala (Dependabot sudah aktif).
- Lisensi default MIT. Ganti jika proyekmu tertutup/komersial, dan ganti nama pemilik di `LICENSE`.

## Kontribusi

Lihat [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), dan [CHANGELOG.md](CHANGELOG.md).
