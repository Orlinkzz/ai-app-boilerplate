<!-- Tahap 4, langkah 3 dari loop per task (lihat docs/ROADMAP.md). Sebaiknya di sesi AI baru. -->
Review perubahan terakhir (`git diff`, atau `git diff main` jika sudah di-commit di branch) sebagai reviewer ketat.

Cek: bug logika, edge case, test yang kurang, konsistensi dengan `AGENTS.md` dan `docs/ARCHITECTURE.md`,
performa, dan keamanan. Cek juga apakah DoD task di `docs/TASKS.md` benar-benar terpenuhi.

Format temuan, urut dari paling parah:
```
[KRITIS|PENTING|KECIL] file:baris — masalah — kenapa itu masalah — saran perbaikan
```

Jangan memperbaiki, cukup laporkan. Jika tidak ada temuan berarti, katakan begitu; jangan mengada-ada.

Di akhir jawaban, tulis bagian **Langkah berikutnya**: aman di-merge atau perlu diperbaiki dulu.
