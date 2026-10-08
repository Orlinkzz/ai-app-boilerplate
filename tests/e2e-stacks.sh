#!/usr/bin/env bash
# Tes end-to-end MANUAL: membuat proyek nyata per stack, menerapkan template, lalu menjalankan
# make deps / lint / test / build. Butuh jaringan (npm registry) dan toolchain terpasang.
# Tidak dijalankan di CI. Pemakaian:
#   bash tests/e2e-stacks.sh            # semua stack yang toolchain-nya tersedia
#   bash tests/e2e-stacks.sh react go   # hanya stack tertentu
# (laravel-react tidak termasuk: butuh PHP + Composer.)
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
PASS=0; FAIL=0; SKIP=0

ok()   { echo "  PASS: $1"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }
skip() { echo "  SKIP: $1"; SKIP=$((SKIP+1)); }
need() { command -v "$1" >/dev/null 2>&1; }

step() { # step "<deskripsi>" <perintah...>
  local d="$1"; shift
  local out
  if out="$("$@" 2>&1)"; then ok "$d"; else bad "$d"; echo "$out" | tail -15 | sed 's/^/      | /'; fi
}
step_fail() { # harus GAGAL
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then bad "$d"; else ok "$d"; fi
}
dev_smoke() { # make dev harus mulai (exit 0 atau di-timeout 124), bukan error perintah
  local out rc
  out="$(timeout 8 make dev 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ] || [ "$rc" -eq 124 ]; then ok "make dev berjalan"; else bad "make dev gagal (rc=$rc)"; echo "$out" | tail -8 | sed 's/^/      | /'; fi
}

# Salin boilerplate (tanpa .git) ke proyek yang sudah ada, lalu terapkan stack
apply_stack() {
  (cd "$ROOT" && tar --exclude=.git --exclude=tests -cf - .) | tar -xf -
  bash scripts/init-stack.sh "$1" >/dev/null
}

run_all() { # jalankan 4 target utama
  step "make deps"  make deps
  step "make lint"  make lint
  step "make test"  make test
  step "make build" make build
}

e2e_react() {
  need npm || { skip "react: npm tidak ada"; return; }
  cd "$WORK" || return; rm -rf react
  if ! npm create vite@latest react -- --template react-ts >/dev/null 2>&1; then bad "react: scaffold gagal"; return; fi
  cd react || return
  apply_stack react
  npm i -D vitest jsdom >/dev/null 2>&1; npm pkg set scripts.test=vitest >/dev/null
  printf "import { expect, test } from 'vitest'\ntest('sum', () => { expect(1 + 1).toBe(2) })\n" > src/sum.test.ts
  run_all; dev_smoke
}

e2e_vue() {
  need npm || { skip "vue: npm tidak ada"; return; }
  cd "$WORK" || return; rm -rf vue
  if ! npm create vue@latest vue -- --ts --vitest --eslint --prettier >/dev/null 2>&1; then bad "vue: scaffold gagal"; return; fi
  cd vue || return
  apply_stack vue
  run_all; dev_smoke
}

e2e_svelte() {
  need npm || { skip "svelte: npm tidak ada"; return; }
  cd "$WORK" || return; rm -rf svelte
  if ! npx -y sv create svelte --template minimal --types ts --no-add-ons --no-install >/dev/null 2>&1; then bad "svelte: scaffold gagal"; return; fi
  cd svelte || return
  apply_stack svelte
  npm i -D vitest >/dev/null 2>&1; npm pkg set scripts.test=vitest >/dev/null
  printf "import { expect, test } from 'vitest'\ntest('sum', () => { expect(1 + 1).toBe(2) })\n" > src/sum.test.ts
  run_all; dev_smoke
}

e2e_nodejs() {
  need npm || { skip "nodejs: npm tidak ada"; return; }
  mkdir -p "$WORK/nodejs/src" "$WORK/nodejs/test" && cd "$WORK/nodejs" || return
  printf '{"name":"app","version":"1.0.0","type":"module","scripts":{"dev":"node --watch src/index.js","test":"node --test","lint":"node --check src/index.js","build":"node --check src/index.js"}}\n' > package.json
  printf 'export const sum = (a, b) => a + b\nconsole.log("up")\n' > src/index.js
  printf "import test from 'node:test'\nimport assert from 'node:assert'\nimport { sum } from '../src/index.js'\ntest('sum', () => { assert.equal(sum(1, 2), 3) })\n" > test/sum.test.js
  npm install >/dev/null 2>&1
  apply_stack nodejs
  run_all; dev_smoke
}

e2e_bun() {
  need bun || { skip "bun: bun tidak terpasang"; return; }
  mkdir -p "$WORK/bun"; cd "$WORK/bun" || return
  if ! bun init -y >/dev/null 2>&1; then bad "bun: init gagal"; return; fi
  mkdir -p src
  printf 'export const sum = (a: number, b: number) => a + b\nconsole.log("up")\n' > src/index.ts
  printf 'import { expect, test } from "bun:test"\nimport { sum } from "./index"\ntest("sum", () => { expect(sum(1, 2)).toBe(3) })\n' > src/index.test.ts
  bun add -d typescript >/dev/null 2>&1
  apply_stack bun
  run_all; dev_smoke
}

e2e_go() {
  need go || { skip "go: go tidak terpasang"; return; }
  mkdir -p "$WORK/go/cmd/app" "$WORK/go/internal/calc" && cd "$WORK/go" || return
  go mod init example.com/app >/dev/null 2>&1
  printf 'package calc\n\nfunc Sum(a, b int) int { return a + b }\n' > internal/calc/calc.go
  printf 'package calc\n\nimport "testing"\n\nfunc TestSum(t *testing.T) {\n\tif Sum(1, 2) != 3 {\n\t\tt.Fatal("salah")\n\t}\n}\n' > internal/calc/calc_test.go
  printf 'package main\n\nimport (\n\t"fmt"\n\n\t"example.com/app/internal/calc"\n)\n\nfunc main() { fmt.Println(calc.Sum(1, 2)) }\n' > cmd/app/main.go
  apply_stack go
  run_all; dev_smoke
  # lint harus menolak file yang belum diformat
  printf 'package calc\nfunc   Bad( ) {}\n' > internal/calc/bad.go
  step_fail "make lint menolak kode yang belum di-gofmt" make lint
}

STACKS=("$@")
if [ "${#STACKS[@]}" -eq 0 ]; then STACKS=(nodejs bun go react vue svelte); fi
for s in "${STACKS[@]}"; do
  echo "== e2e: $s"
  case "$s" in
    react) e2e_react ;; vue) e2e_vue ;; svelte) e2e_svelte ;;
    nodejs) e2e_nodejs ;; bun) e2e_bun ;; go) e2e_go ;;
    *) skip "stack '$s' tidak punya e2e" ;;
  esac
done
echo
echo "Hasil e2e: $PASS lolos, $FAIL gagal, $SKIP dilewati"
[ "$FAIL" -eq 0 ]
