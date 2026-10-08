#!/usr/bin/env bash
# Menjaga instruksi AI tetap satu sumber: AGENTS.md.
#   sync-ai-rules.sh           buat stub yang hilang + perbarui salinan legacy yang diaktifkan
#   sync-ai-rules.sh --check   verifikasi (exit 1 jika stub tidak valid / salinan usang atau hilang)
#   sync-ai-rules.sh --list    cetak path salinan legacy yang aktif
set -euo pipefail
cd "$(dirname "$0")/.."

MODE="${1:-sync}"
SRC="AGENTS.md"
CONF=".ai-sync-targets"
HEADER="<!-- GENERATED dari AGENTS.md oleh scripts/sync-ai-rules.sh. JANGAN EDIT LANGSUNG. -->"

# Stub: tool yang tidak membaca AGENTS.md langsung memakai baris import ke file ini.
STUB_FILES=("CLAUDE.md" "GEMINI.md")
STUB_LINES=("@AGENTS.md" "@./AGENTS.md")

[ -f "$SRC" ] || { echo "AGENTS.md tidak ditemukan" >&2; exit 1; }

# Baca target legacy yang diaktifkan (abaikan komentar dan baris kosong)
TARGETS=()
if [ -f "$CONF" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    if [ -z "$line" ]; then continue; fi
    case "$line" in
      /*|*..*|.git|.git/*|"$SRC"|CLAUDE.md|GEMINI.md)
        echo "Target tidak valid di $CONF: $line" >&2; exit 1 ;;
    esac
    TARGETS+=("$line")
  done < "$CONF"
fi

render() { # $1 = target
  if [[ "$1" == *.mdc ]]; then
    printf '%s\n' "---" "description: Aturan utama proyek (generated dari AGENTS.md)" "alwaysApply: true" "---" ""
  fi
  printf '%s\n\n' "$HEADER"
  cat "$SRC"
}

do_list() {
  local t
  for t in ${TARGETS[@]+"${TARGETS[@]}"}; do echo "$t"; done
}

do_check() {
  local bad=0 i f l t tmp
  for i in 0 1; do
    f="${STUB_FILES[$i]}"; l="${STUB_LINES[$i]}"
    if [ ! -f "$f" ]; then echo "HILANG : $f (harus memuat '$l')"; bad=1
    elif ! grep -qxF "$l" "$f"; then echo "TIDAK VALID: $f harus memuat baris '$l'"; bad=1
    fi
  done
  tmp="$(mktemp -d)"
  for t in ${TARGETS[@]+"${TARGETS[@]}"}; do
    mkdir -p "$(dirname "$tmp/$t")"
    render "$t" > "$tmp/$t"
    if [ ! -f "$t" ]; then echo "HILANG : $t"; bad=1
    elif ! cmp -s "$tmp/$t" "$t"; then echo "USANG  : $t"; bad=1
    fi
  done
  rm -rf "$tmp"
  if [ "$bad" -ne 0 ]; then echo "Instruksi AI tidak sinkron dengan AGENTS.md. Jalankan: make sync-ai"; exit 1; fi
  echo "OK: stub CLAUDE.md/GEMINI.md valid; salinan legacy aktif: ${#TARGETS[@]}"
}

do_sync() {
  local i f l t dest
  for i in 0 1; do
    f="${STUB_FILES[$i]}"; l="${STUB_LINES[$i]}"
    if [ ! -f "$f" ]; then printf '%s\n' "$l" > "$f"; echo "  + dibuat $f"; fi
  done
  if [ "${#TARGETS[@]}" -eq 0 ]; then
    echo "Tidak ada salinan legacy aktif (lihat $CONF). CLAUDE.md dan GEMINI.md meng-import AGENTS.md."
    return 0
  fi
  echo "Sync AGENTS.md ->"
  for t in "${TARGETS[@]}"; do
    dest="$t"
    mkdir -p "$(dirname "$dest")"
    render "$t" > "$dest"
    echo "  ✓ $dest"
  done
}

case "$MODE" in
  sync)    do_sync ;;
  --check) do_check ;;
  --list)  do_list ;;
  *) echo "Pemakaian: $0 [--check|--list]" >&2; exit 2 ;;
esac
