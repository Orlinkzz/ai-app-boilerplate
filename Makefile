.DEFAULT_GOAL := help
.PHONY: help status setup hooks deps dev test lint build sync-ai check-ai selftest init stacks

help:
	@echo "Bingung mulai dari mana? Jalankan: make status   (peta lengkap: docs/ROADMAP.md)"
	@echo
	@echo "Target tersedia:"
	@echo "  make status    Tebak tahap proyek sekarang dan sarankan langkah berikutnya"
	@echo "  make setup     Aktifkan git hook + install dependency"
	@echo "  make deps      Install dependency saja"
	@echo "  make dev       Jalankan mode development"
	@echo "  make test      Jalankan test"
	@echo "  make lint      Jalankan linter/formatter check"
	@echo "  make build     Build untuk production"
	@echo "  make sync-ai   Perbarui salinan legacy yang aktif (.ai-sync-targets); stub dibuat bila hilang"
	@echo "  make check-ai  Verifikasi stub & salinan legacy sinkron dengan AGENTS.md (dipakai CI)"
	@echo "  make selftest  Tes mandiri script sync, hook, dan template stack (untuk maintainer template)"
	@echo "  make stacks    Daftar template stack (bun, nodejs, react, vue, svelte, go, laravel-react)"
	@echo "  make init STACK=<nama>  Terapkan template stack ke AGENTS.md, Makefile, dan CI"

setup: hooks deps

# Hook git: aman dijalankan berulang
hooks:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Belum ada repo git. Jalankan dulu: git init -b main" >&2; exit 1; }
	git config core.hooksPath scripts/hooks
	chmod +x scripts/hooks/* scripts/*.sh
	@echo "Git hook aktif."

# --- Bagian ini diisi otomatis oleh `make init STACK=<nama>` (lihat stacks/) ---
# Placeholder dev/test/lint/build SENGAJA gagal sampai diisi (supaya CI tidak hijau palsu).
# STACK-TARGETS:START
deps:
	@echo "[TODO] 'make deps' belum dikonfigurasi (install dependency). Isi di Makefile atau jalankan: make init STACK=<nama>"

dev:
	@echo "[TODO] 'make dev' belum dikonfigurasi. Isi di Makefile atau jalankan: make init STACK=<nama>" >&2; echo "       Gagal di awal itu normal. Langkah berikutnya: make status" >&2; exit 1

test:
	@echo "[TODO] 'make test' belum dikonfigurasi. Isi di Makefile atau jalankan: make init STACK=<nama>" >&2; echo "       Gagal di awal itu normal (CI juga merah sampai T-001 selesai). Langkah berikutnya: make status" >&2; exit 1

lint:
	@echo "[TODO] 'make lint' belum dikonfigurasi. Isi di Makefile atau jalankan: make init STACK=<nama>" >&2; echo "       Gagal di awal itu normal (CI juga merah sampai T-001 selesai). Langkah berikutnya: make status" >&2; exit 1

build:
	@echo "[TODO] 'make build' belum dikonfigurasi. Isi di Makefile atau jalankan: make init STACK=<nama>" >&2; echo "       Gagal di awal itu normal. Langkah berikutnya: make status" >&2; exit 1
# STACK-TARGETS:END

sync-ai:
	@bash scripts/sync-ai-rules.sh

check-ai:
	@bash scripts/sync-ai-rules.sh --check

selftest:
	@bash tests/test-sync.sh
	@bash tests/test-init.sh
	@bash tests/test-status.sh

init:
	@[ -n "$(STACK)" ] || { echo "Pemakaian: make init STACK=<nama>   (daftar: make stacks)" >&2; exit 1; }
	@bash scripts/init-stack.sh "$(STACK)"

stacks:
	@bash scripts/init-stack.sh --list

status:
	@bash scripts/status.sh
