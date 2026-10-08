#!/usr/bin/env bash
# Menerapkan template stack (stacks/<nama>/) ke AGENTS.md, Makefile, dan .github/workflows/ci.yml.
#   init-stack.sh --list
#   init-stack.sh <stack> [--dry-run]
set -euo pipefail
cd "$(dirname "$0")/.."

STACK_DIR="stacks"
AGENTS="AGENTS.md"
MAKEFILE="Makefile"
CI=".github/workflows/ci.yml"

usage() {
  echo "Pemakaian: $0 --list | <stack> [--dry-run]"
  echo "Contoh   : $0 react"
}

list_stacks() {
  local d
  for d in "$STACK_DIR"/*/; do
    if [ -f "${d}AGENTS.stack.md" ]; then basename "$d"; fi
  done
}

die() { echo "Error: $*" >&2; exit 1; }

# Ganti isi tiap "## Judul" di $1 dengan section bernama sama dari fragmen $2; sisanya ditambah di akhir.
merge_sections() {
  awk -v frag="$2" '
    BEGIN {
      n = 0; cur = ""
      while ((getline line < frag) > 0) {
        if (line ~ /^## /) { cur = line; order[++n] = cur; body[cur] = line "\n" }
        else if (cur != "") { body[cur] = body[cur] line "\n" }
      }
      close(frag)
    }
    {
      if ($0 ~ /^## /) {
        skipping = ($0 in body)
        if (skipping) { printf "%s", body[$0]; used[$0] = 1 }
      }
      if (!skipping) print
    }
    END {
      for (i = 1; i <= n; i++) {
        if (!(order[i] in used)) { print ""; printf "%s", body[order[i]] }
      }
    }' "$1"
}

# Ganti baris di antara marker $2 dan $3 (marker dipertahankan) dengan isi file $4.
replace_block() {
  awk -v s="$2" -v e="$3" -v f="$4" '
    $0 == s { print; while ((getline l < f) > 0) print l; close(f); skip = 1; next }
    $0 == e { skip = 0 }
    !skip   { print }' "$1"
}

ARG="${1:-}"
case "$ARG" in
  ""|-h|--help) usage; exit 0 ;;
  --list)       list_stacks; exit 0 ;;
esac

STACK="$ARG"
DRY=0
if [ -n "${2:-}" ]; then
  if [ "$2" = "--dry-run" ]; then DRY=1; else die "argumen tidak dikenal: $2"; fi
fi

[[ "$STACK" =~ ^[a-z0-9-]+$ ]] || die "nama stack tidak valid: $STACK"
DIR="$STACK_DIR/$STACK"
for f in AGENTS.stack.md Makefile.stack ci-setup.yml; do
  [ -f "$DIR/$f" ] || die "stack '$STACK' tidak ditemukan atau tidak lengkap (butuh $DIR/$f). Daftar: $(list_stacks | tr '\n' ' ')"
done

[ -f "$AGENTS" ]   || die "$AGENTS tidak ditemukan"
[ -f "$MAKEFILE" ] || die "$MAKEFILE tidak ditemukan"
[ -f "$CI" ]       || die "$CI tidak ditemukan"
has_markers() { # $1 file, $2 start, $3 end
  grep -qxF "$2" "$1" && grep -qxF "$3" "$1"
}
if ! has_markers "$MAKEFILE" "# STACK-TARGETS:START" "# STACK-TARGETS:END"; then
  die "marker STACK-TARGETS tidak ada di $MAKEFILE (sudah diubah manual?)"
fi
if ! has_markers "$CI" "      # STACK-SETUP:START" "      # STACK-SETUP:END"; then
  die "marker STACK-SETUP tidak ada di $CI (sudah diubah manual?)"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
merge_sections "$AGENTS" "$DIR/AGENTS.stack.md" > "$TMP/AGENTS.md"
replace_block "$MAKEFILE" "# STACK-TARGETS:START" "# STACK-TARGETS:END" "$DIR/Makefile.stack" > "$TMP/Makefile"
replace_block "$CI" "      # STACK-SETUP:START" "      # STACK-SETUP:END" "$DIR/ci-setup.yml" > "$TMP/ci.yml"

if [ "$DRY" -eq 1 ]; then
  echo "== DRY RUN: stack '$STACK' (tidak ada file yang diubah) =="
  diff -u "$AGENTS" "$TMP/AGENTS.md" || true
  diff -u "$MAKEFILE" "$TMP/Makefile" || true
  diff -u "$CI" "$TMP/ci.yml" || true
  exit 0
fi

# cat > menjaga izin file asli
cat "$TMP/AGENTS.md" > "$AGENTS"
cat "$TMP/Makefile"  > "$MAKEFILE"
cat "$TMP/ci.yml"    > "$CI"

echo "Stack '$STACK' diterapkan ke: $AGENTS, $MAKEFILE, $CI"
echo
echo "Langkah berikutnya:"
echo "  1. Isi 'Nama' dan 'Tujuan' di $AGENTS, lalu hapus blok TEMPLATE-NOTE"
echo "  2. Buat proyeknya sesuai bagian 'Scaffold awal' di $AGENTS"
echo "  3. make setup && make lint && make test"
echo "  4. make check-ai   (jika .ai-sync-targets aktif: make sync-ai dulu)"
echo "  5. Opsional: hapus folder stacks/ dan scripts/init-stack.sh jika sudah tidak dipakai"
