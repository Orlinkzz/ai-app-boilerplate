<!-- Tahap 2 (lihat docs/ROADMAP.md). Pakai setelah PRD lolos review. -->
Berdasarkan `docs/PRD.md`, usulkan arsitektur untuk MVP.

Konteks saya:
- Bahasa/framework yang sudah saya kuasai: <mis. belum ada / sedikit JavaScript / Go>
- Rencana hosting & budget: <mis. gratis dulu / maks Rp100rb per bulan / belum tahu>
- Dikerjakan oleh: <mis. saya sendiri, beberapa jam per minggu>

Yang saya minta:
1. Dua opsi stack dengan trade-off (kemudahan belajar, biaya hosting, kecocokan dengan PRD).
   Utamakan stack yang tersedia di `stacks/` (lihat `stacks/README.md`) agar bisa dipasang dengan `make init`.
2. Rekomendasi satu opsi beserta alasannya.
3. Isi lengkap `docs/ARCHITECTURE.md` mengikuti struktur file yang ada: gambaran umum, struktur folder,
   skema database, daftar endpoint, alur auth (tulis "tidak perlu di MVP" jika memang tidak perlu), deployment.
4. Satu entri `docs/DECISIONS.md` untuk pilihan stack.

Prioritaskan sederhana dan mudah di-maintain satu orang. Jangan menambah komponen yang tidak dibutuhkan PRD.
Jangan menulis kode aplikasi.

Di akhir jawaban, tulis bagian **Langkah berikutnya**: perintah `make init STACK=<nama>` yang sesuai
(atau cara mengisi `Makefile` sendiri jika stack tidak tersedia), lalu `prompts/03-break-into-tasks.md`.
