<!-- Tahap 4, langkah 2 dari loop per task (lihat docs/ROADMAP.md). -->
Rencana disetujui. Implementasikan task <ID> persis sesuai rencana, tanpa keluar scope.

- Tulis test bersamaan.
- Jalankan `make test` dan `make lint`, laporkan hasil sebenarnya (tempel ringkasan output-nya).
- Jika menemukan hal di luar scope, catat di akhir sebagai saran, jangan dikerjakan.
- Jika ada keputusan teknis baru, usulkan entri untuk `docs/DECISIONS.md`.

Di akhir jawaban, tulis bagian **Langkah berikutnya**:
1. Apakah DoD task sudah terpenuhi (ya/tidak, dan buktinya)
2. Review dengan `prompts/06-review-code.md` (dan `prompts/07-security-audit.md` jika menyentuh
   auth, input user, upload, atau data pribadi)
3. Setelah review beres: centang task di `docs/TASKS.md`, commit, lalu pindahkan task berikutnya ke Aktif
