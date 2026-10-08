.DEFAULT_GOAL := help
.PHONY: help setup dev test lint build sync-ai check-ai selftest

help:
	@echo "Target tersedia:"
	@echo "  make setup     Aktifkan git hook + install dependency"
	@echo "  make dev       Jalankan mode development"
	@echo "  make test      Jalankan test"
	@echo "  make lint      Jalankan linter/formatter check"
	@echo "  make build     Build untuk production"
	@echo "  make sync-ai   Perbarui salinan legacy yang aktif (.ai-sync-targets); stub dibuat bila hilang"
	@echo "  make check-ai  Verifikasi stub & salinan legacy sinkron dengan AGENTS.md (dipakai CI)"
	@echo "  make selftest  Tes mandiri script sync & hook (untuk maintainer template)"

# Hook git: aman dijalankan berulang
setup:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Belum ada repo git. Jalankan dulu: git init -b main" >&2; exit 1; }
	git config core.hooksPath scripts/hooks
	chmod +x scripts/hooks/* scripts/*.sh
	@echo "Git hook aktif."
	@echo "[TODO] Tambahkan perintah install dependency di target setup (npm ci / composer install / pip install -r ...)."
	
# --- Target di bawah SENGAJA gagal sampai kamu isi (supaya CI tidak hijau palsu) ---
dev:
	@echo "[TODO] 'make dev' belum dikonfigurasi. Isi di Makefile dan samakan dengan AGENTS.md." >&2; exit 1

test:
	@echo "[TODO] 'make test' belum dikonfigurasi. Isi di Makefile dan samakan dengan AGENTS.md." >&2; exit 1

lint:
	@echo "[TODO] 'make lint' belum dikonfigurasi. Isi di Makefile dan samakan dengan AGENTS.md." >&2; exit 1

build:
	@echo "[TODO] 'make build' belum dikonfigurasi. Isi di Makefile dan samakan dengan AGENTS.md." >&2; exit 1

sync-ai:
	@bash scripts/sync-ai-rules.sh

check-ai:
	@bash scripts/sync-ai-rules.sh --check

selftest:
	@bash tests/test-sync.sh
