# Changelog

Format mengikuti [Keep a Changelog](https://keepachangelog.com/), versi mengikuti [SemVer](https://semver.org/).

## [Unreleased]

### Added
- Situs tutorial statis di `site/` (SEO: meta, Open Graph, JSON-LD, sitemap, robots) dan workflow `pages.yml` untuk GitHub Pages
- `docs/ROADMAP.md`: peta tahap 0-6 dari ide sampai iterasi, dengan prompt, hasil, dan tanda selesai tiap tahap
- Prompt baru: `00-idea-to-prd` (AI mewawancarai pengguna), `03-break-into-tasks`, `09-deploy`, `10-iterate`, `where-am-i`
- `make status` (`scripts/status.sh`) menebak tahap proyek dan menyarankan langkah berikutnya, dengan tes `tests/test-status.sh`
- Perintah Claude Code `/status`
- `examples/kas-kelas/`: contoh proyek yang sudah melewati tahap 0-4, termasuk satu putaran plan → implement → review
- Panduan memilih stack dan jenis hosting di `stacks/README.md`
- Bagian "Arah & Tahap Proyek" di `AGENTS.md`: AI tidak menulis kode aplikasi selama PRD masih placeholder,
  dan menutup jawaban dengan langkah berikutnya

### Changed
- Urutan alur disatukan: PRD dan arsitektur dulu, baru pilih stack (`make init`). Sebelumnya Mulai Cepat
  menyuruh memilih stack lebih dulu, bertentangan dengan prompt arsitektur
- Prompt diberi nomor ulang sesuai tahap (`03-plan-task` → `04`, `04-implement-task` → `05`, `05-review-code` → `06`,
  `06-security-audit` → `07`, `07-debug` → `08`) dan diperkaya dengan format output serta bagian "Langkah berikutnya"
- README disusun ulang: peta jalan dan Mulai Cepat di atas, detail tooling di bagian "Untuk Pengguna Lanjut";
  Mulai Cepat memakai tombol *Use this template*
- `docs/PRD.md` diberi contoh isian dalam komentar; `docs/DECISIONS.md` memakai format ADR dengan status, konteks,
  dan konsekuensi; `docs/TASKS.md` tidak lagi mengasumsikan setiap aplikasi butuh auth
- Pesan placeholder `make test`/`lint`/`dev`/`build` menjelaskan bahwa gagal di awal itu normal

### Fixed
- README menyebut CI punya "dua job" padahal ada tiga

## [1.0.0] - 2026-10-08

### Added
- Template berbasis `AGENTS.md` sebagai sumber tunggal aturan; `CLAUDE.md` dan `GEMINI.md` berisi import ke `AGENTS.md`
- Salinan legacy opsional lewat `.ai-sync-targets` (Cursor, Copilot, Windsurf, Cline) untuk versi tool lama
- `scripts/sync-ai-rules.sh` (mode sync, `--check`, `--list`), pre-commit hook, `Makefile`
- CI: `ai-rules`, `quality`, dan `selftest` (hanya di repo template)
- `tests/test-sync.sh` dan ShellCheck di CI
- `docs/` (PRD, arsitektur, keputusan, task), `prompts/` (7 prompt), perintah `.claude/commands/`
- `stacks/`: template bun, nodejs, react, vue, svelte, go, laravel-react, diterapkan lewat `make init STACK=<nama>`
- `tests/test-init.sh` dan `tests/e2e-stacks.sh` (e2e manual dengan toolchain asli)
- `CONTRIBUTING.md`, `SECURITY.md`, Dependabot untuk GitHub Actions
- Target `make deps`, `make init`, `make stacks`; `make setup` kini = `hooks` + `deps`

### Changed
- Salinan file rules per tool tidak lagi dibuat secara default, karena tool terbaru membaca `AGENTS.md` langsung
  dan salinan bisa membuat instruksi termuat dua kali

### Fixed
- Izin eksekusi script dan hook tercatat di git (`100755`)
- Script dipanggil lewat `bash` agar tidak bergantung izin eksekusi
