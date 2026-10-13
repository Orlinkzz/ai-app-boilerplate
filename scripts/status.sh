#!/usr/bin/env bash
# Menebak tahap proyek (docs/ROADMAP.md) dari isi docs/ dan Makefile, lalu menyarankan langkah berikutnya.
# Heuristik sederhana: baris berisi placeholder <...> dianggap belum diisi (komentar <!-- --> diabaikan).
# Untuk analisis yang lebih teliti, tempel prompts/where-am-i.md ke AI.
set -euo pipefail
cd "$(dirname "$0")/.."

PRD="docs/PRD.md"
ARCH="docs/ARCHITECTURE.md"
TASKS="docs/TASKS.md"

# Jumlah baris berisi placeholder <...>; file hilang dianggap belum diisi
placeholders() {
  if [ ! -f "$1" ]; then echo 999; return; fi
  grep -v '^[[:space:]]*<!--' "$1" | grep -c '<[A-Za-z][^>]*>' || true
}

describe() { # $1 jumlah placeholder
  if [ "$1" -eq 999 ]; then echo "file tidak ada"
  elif [ "$1" -eq 0 ]; then echo "terisi"
  else echo "belum terisi ($1 baris placeholder)"
  fi
}

count() { # $1 pola, $2 file
  if [ -f "$2" ]; then grep -ci "$1" "$2" || true; else echo 0; fi
}

prd_ph="$(placeholders "$PRD")"
arch_ph="$(placeholders "$ARCH")"
tasks_ph="$(placeholders "$TASKS")"
todo="$(count '^- \[ \]' "$TASKS")"
done_n="$(count '^- \[x\]' "$TASKS")"
make_ready=1
if grep -qF "[TODO] 'make test'" Makefile 2>/dev/null; then make_ready=0; fi

echo "== Status proyek =="
echo "PRD          : $(describe "$prd_ph")"
echo "Arsitektur   : $(describe "$arch_ph")"
if [ "$make_ready" -eq 1 ]; then echo "Makefile     : terkonfigurasi"; else echo "Makefile     : belum (stack belum diterapkan)"; fi
echo "Task         : $todo belum, $done_n selesai$( [ "$tasks_ph" -gt 0 ] && echo ", masih ada placeholder" )"
echo

stage=""; next=""
if [ "$prd_ph" -gt 0 ]; then
  stage="0-1 — Ide & PRD"
  next="Isi docs/PRD.md dengan prompts/00-idea-to-prd.md, lalu kritik dengan prompts/01-review-prd.md (sesi baru)."
elif [ "$arch_ph" -gt 0 ]; then
  stage="2 — Arsitektur"
  next="Pakai prompts/02-design-architecture.md untuk mengisi docs/ARCHITECTURE.md dan memilih stack."
elif [ "$make_ready" -eq 0 ]; then
  stage="3 — Setup"
  next="Terapkan stack yang dipilih di docs/ARCHITECTURE.md: make stacks, lalu make init STACK=<nama>."
elif [ "$tasks_ph" -gt 0 ] || [ $((todo + done_n)) -eq 0 ]; then
  stage="3 — Pecah task"
  next="Pakai prompts/03-break-into-tasks.md untuk mengisi docs/TASKS.md dari PRD."
elif [ "$todo" -gt 0 ]; then
  first="$(grep -m1 '^- \[ \]' "$TASKS" | sed 's/^- \[ \] //')"
  stage="4 — Bangun MVP"
  next="Kerjakan: $first. Mulai dengan prompts/04-plan-task.md."
else
  stage="5-6 — Rilis & iterasi"
  next="Semua task selesai. Audit (prompts/07-security-audit.md), rilis (prompts/09-deploy.md), lalu iterasi (prompts/10-iterate.md)."
fi

echo "Tahap sekarang    : $stage"
echo "Langkah berikutnya: $next"

if grep -q 'TEMPLATE-NOTE:START' AGENTS.md 2>/dev/null || grep -q '^- Tujuan: <' AGENTS.md 2>/dev/null; then
  echo
  echo "Catatan: isi Nama/Tujuan di AGENTS.md dan hapus blok TEMPLATE-NOTE, supaya AI tahu proyek ini tentang apa."
fi
echo
echo "Detail tiap tahap: docs/ROADMAP.md"
