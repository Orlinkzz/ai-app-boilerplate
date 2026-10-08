#!/usr/bin/env bash
# Tes mandiri untuk scripts/init-stack.sh dan template di stacks/.
# Jalankan: make selftest
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
PASS=0; FAIL=0

ok()  { echo "  PASS: $1"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }
expect_ok()   { local d="$1"; shift; if "$@" >/dev/null 2>&1; then ok "$d"; else bad "$d"; fi; }
expect_fail() { local d="$1"; shift; if "$@" >/dev/null 2>&1; then bad "$d"; else ok "$d"; fi; }

init_cmd() { bash scripts/init-stack.sh "$@"; }
snapshot()  { cat AGENTS.md Makefile .github/workflows/ci.yml | cksum; }

# Salinan segar dari working tree (tanpa .git)
fresh() {
  rm -rf "$WORK/p"; mkdir "$WORK/p"
  (cd "$ROOT" && tar --exclude=.git -cf - .) | (cd "$WORK/p" && tar -xf -)
  cd "$WORK/p" || exit 1
}

HAVE_YAML=0
if command -v python3 >/dev/null 2>&1 && python3 -c 'import yaml' >/dev/null 2>&1; then HAVE_YAML=1; fi

REQUIRED="bun nodejs react vue svelte go"
ALL="$(cd "$ROOT" && bash scripts/init-stack.sh --list | tr '\n' ' ')"

echo "== 1. Daftar stack"
for s in $REQUIRED; do
  case " $ALL " in *" $s "*) ok "stack '$s' tersedia" ;; *) bad "stack '$s' tidak ada" ;; esac
done

echo "== 2. Kelengkapan tiap template"
for s in $ALL; do
  d="$ROOT/stacks/$s"; good=1
  for h in "## Tech Stack" "## Perintah Penting" "## Struktur Proyek" "## Konvensi Stack"; do
    grep -qxF "$h" "$d/AGENTS.stack.md" || { good=0; echo "    $s: heading hilang: $h"; }
  done
  for t in deps dev test lint build; do
    awk -v t="$t:" '$0==t {f=1; next} f && /^\t[^\t]/ {found=1} f && /^[^\t]/ {f=0} END{exit !found}' "$d/Makefile.stack" \
      || { good=0; echo "    $s: target '$t' tanpa recipe"; }
  done
  grep -q "make deps" "$d/ci-setup.yml" || { good=0; echo "    $s: ci-setup tanpa 'make deps'"; }
  if grep -q '^## ' "$d/AGENTS.stack.md" && grep -n '^```' "$d/AGENTS.stack.md" >/dev/null; then :; fi
  if [ "$good" -eq 1 ]; then ok "$s lengkap"; else bad "$s tidak lengkap"; fi
done

echo "== 3. Penolakan input berbahaya / salah"
fresh
before="$(snapshot)"
for bad_name in "../scripts" "BUN" "bun/.." "nope" "a b" "./react" "react/" "react/../react"; do
  expect_fail "menolak nama stack: '$bad_name'" init_cmd "$bad_name"
done
expect_fail "menolak argumen kedua yang tidak dikenal" init_cmd bun --ngawur
if [ "$(snapshot)" = "$before" ]; then ok "file tidak berubah setelah input ditolak"; else bad "file berubah oleh input ditolak"; fi

echo "== 4. Dry-run"
fresh
before="$(snapshot)"
expect_ok "dry-run sukses" init_cmd react --dry-run
if [ "$(snapshot)" = "$before" ]; then ok "dry-run tidak mengubah file"; else bad "dry-run mengubah file"; fi

echo "== 5. Terapkan tiap stack"
for s in $ALL; do
  fresh
  expect_ok "$s: init sukses" init_cmd "$s"
  if grep -q '<isi' AGENTS.md; then bad "$s: placeholder '<isi' masih ada"; else ok "$s: placeholder stack terisi"; fi
  if grep -qxF "Stack: $(sed -n 's/^Stack: //p' "$ROOT/stacks/$s/AGENTS.stack.md")" AGENTS.md; then ok "$s: konvensi stack ditulis"; else bad "$s: konvensi stack tidak ada"; fi
  todo=0
  for t in deps dev test lint build; do
    out="$(make -n "$t" 2>&1)" || { todo=1; echo "    make -n $t gagal"; }
    case "$out" in *"[TODO]"*) todo=1 ;; esac
  done
  if [ "$todo" -eq 0 ]; then ok "$s: semua target Makefile terdefinisi (tanpa [TODO])"; else bad "$s: ada target belum terdefinisi"; fi
  expect_ok "$s: check-ai tetap lolos" make check-ai
  if grep -q "make deps" .github/workflows/ci.yml && grep -qxF "      # STACK-SETUP:END" .github/workflows/ci.yml; then ok "$s: CI memuat setup + marker utuh"; else bad "$s: CI tidak benar"; fi
  if [ "$HAVE_YAML" -eq 1 ]; then
    expect_ok "$s: ci.yml valid YAML" python3 -c 'import yaml,sys; yaml.safe_load(open(".github/workflows/ci.yml"))'
  fi
  a="$(snapshot)"; init_cmd "$s" >/dev/null 2>&1
  if [ "$(snapshot)" = "$a" ]; then ok "$s: idempoten (dua kali = sama)"; else bad "$s: tidak idempoten"; fi
done

echo "== 6. Ganti stack"
fresh
init_cmd react >/dev/null 2>&1
init_cmd go >/dev/null 2>&1
if grep -q "npm run dev" Makefile; then bad "sisa perintah React di Makefile"; else ok "Makefile berganti ke Go"; fi
if [ "$(grep -c '^## Konvensi Stack' AGENTS.md)" = "1" ] && ! grep -q "Stack: React" AGENTS.md; then ok "AGENTS.md hanya memuat konvensi stack terbaru"; else bad "konvensi stack menumpuk"; fi
if grep -q "setup-go" .github/workflows/ci.yml && ! grep -q "setup-node" .github/workflows/ci.yml; then ok "CI berganti ke Go"; else bad "CI tidak berganti"; fi

echo "== 7. Marker hilang -> tolak tanpa mengubah apa pun"
fresh
grep -vxF "# STACK-TARGETS:END" Makefile > Makefile.tmp && cat Makefile.tmp > Makefile && rm Makefile.tmp
before="$(snapshot)"
expect_fail "init ditolak jika marker Makefile hilang" init_cmd bun
if [ "$(snapshot)" = "$before" ]; then ok "tidak ada perubahan parsial"; else bad "terjadi perubahan parsial"; fi

echo
echo "Hasil: $PASS lolos, $FAIL gagal"
[ "$FAIL" -eq 0 ]
