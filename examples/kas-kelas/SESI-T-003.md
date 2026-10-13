# Contoh Satu Putaran Task: T-003

Ringkasan satu sesi kerja dengan AI untuk task T-003 "Tandai pembayaran minggu ini".
Percakapan dipersingkat; yang penting adalah **urutan dan apa yang dicek manusia** di tiap langkah.

## 1. Rencana (`prompts/04-plan-task.md`)

Rencana dari AI:
1. `src/lib/minggu.ts`: fungsi `mingguISO(tanggal)` → `"2026-W41"` (DECISIONS 0002)
2. `src/lib/storage.ts`: tambah `toggleBayar(siswaId, minggu)`
3. `src/components/MingguIni.tsx`: daftar siswa aktif + status lunas, ketuk untuk toggle
4. Test: `minggu.test.ts` (termasuk 29 Des – 4 Jan), `MingguIni.test.tsx` (toggle + tersimpan)
5. Di luar scope: tunggakan (T-004), memilih minggu lain

**Dicek manusia:** AI awalnya juga mengusulkan "pilih minggu sebelumnya". Ditolak karena tidak ada di DoD;
dicatat sebagai ide untuk Backlog. Setelah itu rencana disetujui.

## 2. Implementasi (`prompts/05-implement-task.md`)

AI menulis kode dan test, lalu melaporkan:
```
make test  → 14 passed
make lint  → 0 problems
DoD: terpenuhi (toggle lunas/batal, tersimpan setelah reload, minggu tampil sebagai ISO week)
Di luar scope (saran): tombol "pilih minggu lain"
```

**Dicek manusia:** menjalankan `make dev`, mencoba di layar HP (DevTools 360px), memuat ulang halaman.

## 3. Review (`prompts/06-review-code.md`, sesi AI baru)

Temuan:
```
[PENTING] src/lib/minggu.ts:12 — tahun diambil dari tanggal, bukan dari minggunya; 1 Jan 2027 menjadi
          "2027-W53", seharusnya "2026-W53" — ikuti aturan ISO (tahun = tahun hari Kamis di minggu itu)
          — tambah test 1 Jan 2027
[KECIL]   src/components/MingguIni.tsx:30 — tombol tanpa label aksesibel — tambahkan aria-pressed
```

**Dicek manusia:** meminta AI memperbaiki dua temuan itu saja (masih dalam scope T-003), test baru ditambahkan
dan lolos.

## 4. Selesai

- Centang T-003 di `TASKS.md`, pindahkan T-004 ke Aktif.
- Commit: `feat: tandai pembayaran minggu ini (T-003)`
- Ide "pilih minggu lain" dicatat di Backlog PRD versi berikutnya, bukan dikerjakan sekarang.
