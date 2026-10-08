# Changelog

Format mengikuti [Keep a Changelog](https://keepachangelog.com/), versi mengikuti [SemVer](https://semver.org/).

## [Unreleased]

## [1.0.0] - 2026-10-08

### Added
- Template berbasis `AGENTS.md` sebagai sumber tunggal aturan; `CLAUDE.md` dan `GEMINI.md` berisi import ke `AGENTS.md`
- Salinan legacy opsional lewat `.ai-sync-targets` (Cursor, Copilot, Windsurf, Cline) untuk versi tool lama
- `scripts/sync-ai-rules.sh` (mode sync, `--check`, `--list`), pre-commit hook, `Makefile`
- CI: `ai-rules`, `quality`, dan `selftest` (hanya di repo template)
- `tests/test-sync.sh` dan ShellCheck di CI
- `docs/` (PRD, arsitektur, keputusan, task), `prompts/` (7 prompt), perintah `.claude/commands/`
- `examples/laravel-react/`, `CONTRIBUTING.md`, `SECURITY.md`, Dependabot untuk GitHub Actions

### Changed
- Salinan file rules per tool tidak lagi dibuat secara default, karena tool terbaru membaca `AGENTS.md` langsung
  dan salinan bisa membuat instruksi termuat dua kali

### Fixed
- Izin eksekusi script dan hook tercatat di git (`100755`)
- Script dipanggil lewat `bash` agar tidak bergantung izin eksekusi
