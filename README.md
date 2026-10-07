# AI App Boilerplate

Template repo untuk memulai aplikasi dengan **AI-assisted development** yang tidak terkunci ke satu tool.
Satu aturan (`AGENTS.md`), dibaca oleh banyak AI.

## Tool yang Didukung

| Tool | File yang dibaca | Sumber |
|---|---|---|
| Claude Code | `CLAUDE.md` (import `AGENTS.md`) | langsung |
| OpenAI Codex, Jules, Copilot agent | `AGENTS.md` | langsung |
| Aider | `.aider.conf.yml` -> `AGENTS.md` | langsung |
| Gemini CLI | `GEMINI.md` | generated |
| GitHub Copilot | `.github/copilot-instructions.md` | generated |
| Cursor | `.cursor/rules/project.mdc` | generated |
| Windsurf | `.windsurfrules` | generated |
| Cline / Roo Code | `.clinerules` | generated |

> Nama file tiap tool bisa berubah seiring versi. Cek dokumentasi tool yang kamu pakai; jika berubah,
> cukup ubah daftar `TARGETS` di `scripts/sync-ai-rules.sh`.

## Mulai Cepat

```bash
git clone https://github.com/Orlinkzz/ai-app-boilerplate.git nama-app && cd nama-app && rm -rf .git && git init

# 1. Isi AGENTS.md (nama, stack) dan ganti orlinkzz di LICENSE
# 2. Aktifkan hook + sync rules
make setup
make sync-ai
# 3. Isi target dev/test/lint/build di Makefile
```

## Perintah `make`

| Perintah | Fungsi |
|---|---|
| `make setup` | Aktifkan git hook (+ tempat install dependency) |
| `make dev` / `test` / `lint` / `build` | Placeholder. **Sengaja gagal** sampai kamu isi, agar CI tidak hijau palsu |
| `make sync-ai` | Generate file rules semua AI dari `AGENTS.md` |
| `make check-ai` | Verifikasi file rules sinkron (mendeteksi usang dan hilang) |

## Pengaman Otomatis

**Pre-commit hook** (aktif setelah `make setup`):
1. Menolak commit file `.env` / `.env.*` (kecuali `.env.example`)
2. Jika `AGENTS.md` ikut di-commit, otomatis sync dan stage file hasil generate
3. Menolak commit jika file rules usang

**CI** (`.github/workflows/ci.yml`), dua job:
- `ai-rules`: `make check-ai`
- `quality`: `make lint` dan `make test`. Akan merah sampai kamu mengisi Makefile dan setup runtime di workflow.
  Itu disengaja: task pertama (T-001) adalah membuatnya hijau.

## Alur Kerja

1. `prompts/01-review-prd.md` — tulis `docs/PRD.md`, minta AI mengkritiknya
2. `prompts/02-design-architecture.md` — isi `docs/ARCHITECTURE.md`
3. Pecah jadi task kecil di `docs/TASKS.md`
4. Per task: `03-plan-task` -> review rencana -> `04-implement-task`
5. `05-review-code` dan `06-security-audit` sebelum merge
6. Bug? `07-debug`
7. Keputusan penting dicatat di `docs/DECISIONS.md`

Prompt di `prompts/` bisa dipakai di AI mana pun (chat, IDE, CLI), cukup copy-paste.

## Menambah Tool Baru

Tambahkan satu entri di array `TARGETS` pada `scripts/sync-ai-rules.sh`, lalu `make sync-ai`.
Tambahkan juga path-nya di `.gitattributes` dan di `git add` pada `scripts/hooks/pre-commit`.

## Catatan

- Hook bisa dilewati dengan `git commit --no-verify`, tapi CI tetap menangkapnya.
- Versi action di CI (`actions/checkout@v4`) perlu diperbarui berkala.
- Lisensi default MIT. Ganti jika proyekmu tertutup/komersial.

## Prinsip

- Kamu arsitek, AI eksekutor.
- Task kecil, commit sering, test selalu.
- Kode yang jalan belum tentu benar atau aman. Baca dan review sendiri.
