# Kontribusi

Terima kasih sudah mau membantu. Repo ini kecil dan sengaja sederhana.

## Prinsip

- Aturan untuk AI ditulis di **`AGENTS.md`** saja. Jangan edit salinan legacy hasil generate secara langsung.
- Perubahan kecil dan fokus lebih disukai daripada PR besar.
- Gunakan [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`).

## Sebelum membuka PR

```bash
make setup       # aktifkan git hook
make check-ai    # stub CLAUDE.md/GEMINI.md valid & salinan legacy (jika aktif) sinkron
make selftest    # tes mandiri script sync & hook
shellcheck scripts/*.sh scripts/hooks/pre-commit tests/*.sh
```

CI menjalankan hal yang sama. Job `Lint & Test` memang tidak jalan di repo template ini.

## Menambah atau mengubah dukungan tool AI

1. Cek dokumentasi resmi tool tersebut. Sertakan tautannya di deskripsi PR.
2. Jika tool itu sudah membaca `AGENTS.md`, cukup perbarui dokumentasi. Jika perlu file sendiri, tambahkan
   sebagai opsi (dikomentari) di `.ai-sync-targets`, ubah `scripts/sync-ai-rules.sh` bila formatnya khusus,
   dan tambahkan skenario tes di `tests/test-sync.sh`.
3. Perbarui tabel dan catatan kompatibilitas di `README.md`.

Jangan menambah klaim "didukung" untuk tool yang belum kamu coba atau belum terdokumentasi.

## Melaporkan bug

Sertakan sistem operasi, versi `git`/`bash`/`make`, perintah yang dijalankan, dan output lengkapnya.
Untuk kerentanan keamanan, ikuti [SECURITY.md](SECURITY.md), jangan buka issue publik.

## Pengguna Windows

Gunakan WSL atau Git Bash. Di Windows, izin eksekusi script bisa hilang saat commit. Perbaiki dengan:

```bash
git update-index --chmod=+x scripts/sync-ai-rules.sh scripts/hooks/pre-commit tests/test-sync.sh
```

Cek hasilnya dengan `git ls-files -s scripts tests` (kolom pertama harus `100755`).
