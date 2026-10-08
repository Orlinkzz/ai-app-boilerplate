#!/usr/bin/env bash
# Menyalin AGENTS.md ke format yang dibaca tiap AI tool.
#   ./scripts/sync-ai-rules.sh           -> tulis file hasil generate
#   ./scripts/sync-ai-rules.sh --check   -> hanya verifikasi (exit 1 jika tidak sinkron / hilang)
set -euo pipefail
cd "$(dirname "$0")/.."

MODE="${1:-sync}"
SRC="AGENTS.md"
[ -f "$SRC" ] || { echo "AGENTS.md tidak ditemukan"; exit 1; }

HEADER="<!-- GENERATED dari AGENTS.md oleh scripts/sync-ai-rules.sh. JANGAN EDIT LANGSUNG. -->"

# Daftar target. Untuk menambah tool baru: tambah satu entri di sini.
TARGETS=(
  "GEMINI.md"                         # Gemini CLI
  ".github/copilot-instructions.md"   # GitHub Copilot
  ".windsurfrules"                    # Windsurf
  ".clinerules"                       # Cline / Roo Code
  ".cursor/rules/project.mdc"         # Cursor (butuh frontmatter)
)

if [ "$MODE" = "--check" ]; then
  OUT="$(mktemp -d)"; trap 'rm -rf "$OUT"' EXIT
else
  OUT="."
fi

render() { # $1 = target
  if [[ "$1" == *.mdc ]]; then
    printf '%s\n' "---" "description: Aturan utama proyek (generated dari AGENTS.md)" "alwaysApply: true" "---" ""
  fi
  printf '%s\n\n' "$HEADER"
  cat "$SRC"
}

for t in "${TARGETS[@]}"; do
  mkdir -p "$(dirname "$OUT/$t")"
  render "$t" > "$OUT/$t"
done

if [ "$MODE" = "--check" ]; then
  bad=0
  for t in "${TARGETS[@]}"; do
    if [ ! -f "$t" ]; then echo "HILANG : $t"; bad=1
    elif ! cmp -s "$OUT/$t" "$t"; then echo "USANG  : $t"; bad=1
    fi
  done
  if [ "$bad" -ne 0 ]; then echo "Rules AI tidak sinkron dengan AGENTS.md. Jalankan: make sync-ai"; exit 1; fi
  echo "OK: semua file rules AI sinkron."
else
  echo "Sync AGENTS.md ->"
  for t in "${TARGETS[@]}"; do echo "  ✓ $t"; done
  echo "(CLAUDE.md & .aider.conf.yml merujuk langsung ke AGENTS.md)"
fi
