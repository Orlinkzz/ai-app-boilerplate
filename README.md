# AI App Boilerplate

[![CI](https://github.com/Orlinkzz/ai-app-boilerplate/actions/workflows/ci.yml/badge.svg)](https://github.com/Orlinkzz/ai-app-boilerplate/actions/workflows/ci.yml)

> *One `AGENTS.md`, many AI coding tools.* A template for AI-assisted app development
> (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Windsurf, Cline, Aider). Documentation is in Indonesian.

Template repo untuk memulai aplikasi dengan **AI-assisted development** yang tidak terkunci ke satu tool.
Satu aturan (`AGENTS.md`), dibaca oleh banyak AI.

## Tool yang Ditargetkan

| Tool | Cara membaca instruksi | Di repo ini |
|---|---|---|
| Codex, Jules, Cursor, Windsurf, Cline, GitHub Copilot | membaca `AGENTS.md` langsung (bergantung versi) | tidak perlu file tambahan |
| Claude Code | hanya membaca `CLAUDE.md` | `CLAUDE.md` berisi `@AGENTS.md` |
| Gemini CLI | membaca `GEMINI.md` | `GEMINI.md` berisi `@./AGENTS.md` |
| Aider | konfigurasi `read:` | `.aider.conf.yml` merujuk ke `AGENTS.md` |

> Tabel ini disusun dari dokumentasi tiap tool dan **belum diuji langsung di semua tool**.
> Jika ada yang tidak bekerja, buka issue.

## Mulai Cepat

**Prasyarat:** `git`, `make`, dan `bash`. Di Windows gunakan **WSL** atau **Git Bash**.

```bash
git clone https://github.com/Orlinkzz/ai-app-boilerplate.git nama-app && cd nama-app && rm -rf .git && git init

# 1. Pilih stack (disarankan)
make stacks
make init STACK=react

# 2. Isi AGENTS.md (nama, tujuan), cek nama pemilik di LICENSE
# 3. Aktifkan git hook
make setup

# Tanpa stack: isi sendiri target deps/dev/test/lint/build di Makefile
```

## Perintah `make`

| Perintah | Fungsi |
|---|---|
| `make setup` | Aktifkan git hook, lalu `make deps` |
| `make deps` | Install dependency (terisi oleh `make init`) |
| `make stacks` / `make init STACK=<nama>` | Daftar / terapkan template stack |
| `make dev` / `test` / `lint` / `build` | Placeholder. **Sengaja gagal** sampai kamu isi (atau `make init`), agar CI tidak hijau palsu |
| `make sync-ai` | Perbarui salinan legacy yang aktif di `.ai-sync-targets` (dan buat stub yang hilang) |
| `make check-ai` | Verifikasi stub `CLAUDE.md`/`GEMINI.md` dan salinan legacy aktif (mendeteksi usang dan hilang) |
| `make selftest` | Tes mandiri script sync dan hook (untuk maintainer template) |

## Pengaman Otomatis

**Pre-commit hook** (aktif setelah `make setup`):
1. Menolak commit file `.env` / `.env.*` (kecuali `.env.example`)
2. Jika `AGENTS.md` ikut di-commit dan ada salinan legacy aktif, otomatis sync dan stage salinannya
3. Menolak commit jika stub tidak valid atau salinan legacy usang

**CI** (`.github/workflows/ci.yml`), dua job:
- `ai-rules`: `make check-ai`
- `selftest`: ShellCheck + `make selftest` (tes sync, hook, dan template stack). **Hanya jalan di repo template ini**, bukan di repo turunan.
- `quality`: `make lint` dan `make test`. Akan merah sampai kamu mengisi Makefile dan setup runtime di workflow.
  Itu disengaja: task pertama (T-001) adalah membuatnya hijau. `make init` mengisi setup runtime-nya otomatis.

## Template Stack

Pilih stack dan terapkan dalam satu perintah: `make init STACK=<nama>`.

Tersedia: **bun, nodejs, react, vue, svelte, go, laravel-react**. Perintah `make init` mengisi `AGENTS.md`,
target `Makefile`, dan setup CI sekaligus. Detail, status uji, dan cara menambah stack ada di
[`stacks/README.md`](stacks/README.md). Enam stack pertama sudah diuji end-to-end dengan toolchain asli;
`laravel-react` belum.

## Alur Kerja

1. `prompts/01-review-prd.md` — tulis `docs/PRD.md`, minta AI mengkritiknya
2. `prompts/02-design-architecture.md` — isi `docs/ARCHITECTURE.md`
3. Pecah jadi task kecil di `docs/TASKS.md`
4. Per task: `03-plan-task` -> review rencana -> `04-implement-task`
5. `05-review-code` dan `06-security-audit` sebelum merge
6. Bug? `07-debug`
7. Keputusan penting dicatat di `docs/DECISIONS.md`

Prompt di `prompts/` bisa dipakai di AI mana pun (chat, IDE, CLI), cukup copy-paste.

## Salinan Legacy (opsional)

Versi tool yang lebih lama mungkin belum membaca `AGENTS.md`. Untuk itu `.ai-sync-targets` menyediakan daftar
salinan opsional, **semuanya nonaktif secara default**: `.cursor/rules/project.mdc`,
`.github/copilot-instructions.md`, `.windsurfrules`, dan `.clinerules`.

Aktifkan dengan menghapus tanda `#` di barisnya, lalu jalankan `make sync-ai`. Catatan dari dokumentasi tool
(dicek Oktober 2026; konvensi bisa berubah):

- Windsurf kini memakai `.windsurf/rules/*.md`; `.windsurfrules` adalah format lama.
- Cline merekomendasikan folder `.clinerules/`; jika `.clinerules` ada, ia diprioritaskan di atas `AGENTS.md`.
- Di tool yang sudah membaca `AGENTS.md`, salinan bisa membuat instruksi yang sama termuat dua kali.

## Menambah Tool Baru

Tool yang sudah membaca `AGENTS.md` tidak perlu apa-apa. Jika butuh file sendiri, tambahkan sebagai baris
dikomentari di `.ai-sync-targets`. Untuk format khusus (mis. frontmatter), ubah fungsi `render()` di
`scripts/sync-ai-rules.sh` dan tambahkan skenario tes di `tests/test-sync.sh`.

## Catatan

- Hook bisa dilewati dengan `git commit --no-verify`, tapi CI tetap menangkapnya.
- Versi action di CI (`actions/checkout@v4`) perlu diperbarui berkala.
- Lisensi default MIT. Ganti jika proyekmu tertutup/komersial.

## Kontribusi

Lihat [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), dan [CHANGELOG.md](CHANGELOG.md).

## Prinsip

- Kamu arsitek, AI eksekutor.
- Task kecil, commit sering, test selalu.
- Kode yang jalan belum tentu benar atau aman. Baca dan review sendiri.
