#!/usr/bin/env bash
# Tes mandiri untuk scripts/sync-ai-rules.sh dan scripts/hooks/pre-commit.
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

sync_cmd() { bash scripts/sync-ai-rules.sh "$@"; }

# Salinan segar dari working tree -> repo git sementara dengan hook aktif
new_repo() {
  rm -rf "$WORK/r"; mkdir "$WORK/r"
  (cd "$ROOT" && tar --exclude=.git -cf - .) | (cd "$WORK/r" && tar -xf -)
  cd "$WORK/r" || exit 1
  git -c init.defaultBranch=main init -q
  git config user.email t@t; git config user.name t
  git config core.hooksPath scripts/hooks
  chmod +x scripts/hooks/pre-commit
  git add -A; git commit -q --no-verify -m init
}

# Aktifkan salinan legacy: enable_legacy <path>...
enable_legacy() {
  printf '%s\n' "$@" > .ai-sync-targets
  sync_cmd sync >/dev/null 2>&1
  git add -A; git commit -q --no-verify -m "enable legacy"
}

echo "== 1. Izin eksekusi di repo sumber"
if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -n "$(git -C "$ROOT" ls-files scripts)" ]; then
  for f in scripts/sync-ai-rules.sh scripts/hooks/pre-commit; do
    mode="$(git -C "$ROOT" ls-files -s "$f" | cut -d' ' -f1)"
    if [ "$mode" = "100755" ]; then ok "$f tercatat 100755 di git"; else bad "$f mode git = $mode (harus 100755)"; fi
  done
else
  echo "  (bukan repo git, dilewati)"
fi

echo "== 2. Default: tanpa salinan legacy"
new_repo
expect_ok "check lolos pada kondisi awal" sync_cmd --check
if [ -z "$(sync_cmd --list)" ]; then ok "--list kosong secara default"; else bad "--list tidak kosong"; fi
if [ ! -e .windsurfrules ] && [ ! -e .clinerules ] && [ ! -e .cursor ] && [ ! -e .github/copilot-instructions.md ]; then
  ok "repo tidak membawa salinan legacy"
else
  bad "repo masih membawa salinan legacy"
fi
expect_fail "mode tidak dikenal ditolak" sync_cmd --ngawur

echo "== 3. Stub CLAUDE.md / GEMINI.md"
printf 'kosong\n' > CLAUDE.md
expect_fail "check gagal jika CLAUDE.md tanpa import" sync_cmd --check
git checkout -q CLAUDE.md
rm -f GEMINI.md
expect_fail "check gagal jika GEMINI.md hilang" sync_cmd --check
sync_cmd sync >/dev/null 2>&1
if grep -qxF '@./AGENTS.md' GEMINI.md; then ok "sync membuat ulang stub GEMINI.md"; else bad "stub GEMINI.md tidak dibuat"; fi
expect_ok "check lolos setelah stub dibuat ulang" sync_cmd --check

echo "== 4. Validasi .ai-sync-targets"
new_repo
before="$(cksum < AGENTS.md)"
for t in "AGENTS.md" "CLAUDE.md" "../luar.md" "/tmp/luar.md" ".git/hooks/x"; do
  printf '%s\n' "$t" > .ai-sync-targets
  expect_fail "menolak target tidak valid: $t" sync_cmd sync
done
if [ "$(cksum < AGENTS.md)" = "$before" ]; then ok "AGENTS.md tidak rusak oleh target berbahaya"; else bad "AGENTS.md berubah!"; fi
printf '%s\n' "  .clinerules   # komentar inline" "" "# baris komentar" > .ai-sync-targets
sync_cmd sync >/dev/null 2>&1
if [ -f .clinerules ]; then ok "parser mengabaikan spasi dan komentar"; else bad "parser salah membaca config"; fi

echo "== 5. Salinan legacy aktif"
new_repo
enable_legacy .windsurfrules .cursor/rules/project.mdc
expect_ok "check lolos setelah legacy diaktifkan" sync_cmd --check
if [ "$(sync_cmd --list | wc -l | tr -d ' ')" = "2" ]; then ok "--list menampilkan 2 target aktif"; else bad "--list salah"; fi
echo "SALAH" >> .windsurfrules
expect_fail "mendeteksi salinan USANG" sync_cmd --check
git checkout -q .windsurfrules
rm -f .cursor/rules/project.mdc
expect_fail "mendeteksi salinan HILANG" sync_cmd --check
git checkout -q .cursor/rules/project.mdc
echo "- aturan uji" >> AGENTS.md
expect_fail "AGENTS.md berubah -> check gagal sebelum sync" sync_cmd --check
sync_cmd sync >/dev/null 2>&1
if grep -q "aturan uji" .windsurfrules && grep -q "aturan uji" .cursor/rules/project.mdc; then ok "sync menyebarkan perubahan"; else bad "sync tidak menyebarkan perubahan"; fi
if head -4 .cursor/rules/project.mdc | grep -q "alwaysApply"; then ok "frontmatter Cursor (.mdc) benar"; else bad "frontmatter Cursor hilang"; fi

echo "== 6. Hook tanpa salinan legacy"
new_repo
echo "- aturan hook" >> AGENTS.md
git add AGENTS.md
expect_ok "commit AGENTS.md lolos" git commit -q -m "docs: ubah aturan"
if [ ! -e .windsurfrules ]; then ok "hook tidak membuat salinan yang tidak diaktifkan"; else bad "hook membuat salinan tak diminta"; fi
printf 'kosong\n' > CLAUDE.md
git add CLAUDE.md
expect_fail "hook menolak commit saat stub CLAUDE.md tidak valid" git commit -q -m "bad"
git reset -q HEAD CLAUDE.md; git checkout -q CLAUDE.md
echo "SECRET=1" > .env
git add -f .env
expect_fail "hook menolak commit .env" git commit -q -m "leak"
git reset -q HEAD .env; rm -f .env
echo "# contoh" >> .env.example
git add .env.example
expect_ok ".env.example tetap boleh di-commit" git commit -q -m "docs: env example"

echo "== 7. Hook dengan salinan legacy"
new_repo
enable_legacy .windsurfrules
echo "- aturan hook" >> AGENTS.md
git add AGENTS.md
if git commit -q -m "docs: ubah aturan" >/dev/null 2>&1 && git show --name-only --format= HEAD | grep -qx ".windsurfrules"; then
  ok "hook auto-sync + stage salinan legacy"
else
  bad "hook tidak auto-sync salinan legacy"
fi
expect_ok "check lolos setelah commit" sync_cmd --check
echo "usang" >> .windsurfrules
git add .windsurfrules
expect_fail "hook menolak commit salinan usang" git commit -q -m "bad"

echo
echo "Hasil: $PASS lolos, $FAIL gagal"
[ "$FAIL" -eq 0 ]
