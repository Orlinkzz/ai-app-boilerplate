#!/usr/bin/env bash
# Tes mandiri untuk scripts/status.sh: tahap yang ditebak harus maju sesuai isi docs/ dan Makefile.
# Jalankan: make selftest
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
PASS=0; FAIL=0

ok()  { echo "  PASS: $1"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

# Salinan segar dari working tree (tanpa .git)
fresh() {
  rm -rf "$WORK/p"; mkdir "$WORK/p"
  (cd "$ROOT" && tar --exclude=.git -cf - .) | (cd "$WORK/p" && tar -xf -)
  cd "$WORK/p" || exit 1
}

expect_stage() { # $1 deskripsi, $2 awalan tahap yang diharapkan
  local out
  out="$(bash scripts/status.sh 2>&1)" || { bad "$1 (status.sh keluar dengan error)"; return; }
  if printf '%s\n' "$out" | grep -q "^Tahap sekarang    : $2"; then ok "$1"; else
    bad "$1"; printf '%s\n' "$out" | sed 's/^/    | /'
  fi
}

echo "== 1. Kondisi awal template"
fresh
expect_stage "template baru -> tahap 0-1 (PRD)" "0-1"
if bash scripts/status.sh | grep -q "TEMPLATE-NOTE"; then ok "mengingatkan blok TEMPLATE-NOTE"; else bad "tidak mengingatkan TEMPLATE-NOTE"; fi

echo "== 2. Tahap maju sesuai isi dokumen"
printf '# PRD\n\n## 1. Masalah\nBendahara salah hitung iuran.\n<!-- komentar <diabaikan> -->\n' > docs/PRD.md
expect_stage "PRD terisi -> tahap 2 (arsitektur)" "2 "
printf '# Arsitektur\n\nStack: go\n' > docs/ARCHITECTURE.md
expect_stage "arsitektur terisi, Makefile belum -> tahap 3 (setup)" "3 — Setup"
bash scripts/init-stack.sh go >/dev/null 2>&1
expect_stage "stack diterapkan, task masih template -> tahap 3 (pecah task)" "3 — Pecah task"
printf '# Task\n\n## Aktif\n- [x] T-001 Setup\n- [ ] T-002 Catat pembayaran\n' > docs/TASKS.md
expect_stage "ada task terbuka -> tahap 4" "4 "
if bash scripts/status.sh | grep -q "T-002 Catat pembayaran"; then ok "menyebut task terbuka pertama"; else bad "tidak menyebut task terbuka"; fi
printf '# Task\n\n## Selesai\n- [x] T-001 Setup\n- [X] T-002 Catat pembayaran\n' > docs/TASKS.md
expect_stage "semua task selesai -> tahap 5-6" "5-6"

echo "== 3. File hilang tidak membuat script crash"
fresh
rm -f docs/PRD.md docs/TASKS.md
expect_stage "PRD hilang -> tahap 0-1" "0-1"

echo
echo "Hasil: $PASS lolos, $FAIL gagal"
[ "$FAIL" -eq 0 ]
