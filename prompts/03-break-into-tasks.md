<!-- Tahap 3 (lihat docs/ROADMAP.md). Pakai setelah arsitektur dan stack ditentukan. -->
Baca `docs/PRD.md`, `docs/ARCHITECTURE.md`, dan `docs/TASKS.md`.
Pecah scope MVP menjadi daftar task untuk `docs/TASKS.md`.

Aturan task:
- **Vertikal**: tiap task menghasilkan sesuatu yang bisa dicoba (mis. "user bisa menambah transaksi"),
  bukan lapisan teknis terpisah ("buat semua model", "buat semua endpoint").
- **Kecil**: selesai dalam satu sesi AI dan satu commit/PR. Jika ragu, pecah lagi.
- Tiap task punya **DoD** (Definition of Done) yang bisa dites, dan menyebut task yang harus selesai lebih dulu.
- T-001 (setup project) tetap paling atas. Task pertama setelahnya sebaiknya alur utama paling sederhana
  dari ujung ke ujung, walau masih kasar.
- Jangan membuat task untuk fitur di bagian "TIDAK masuk" PRD.

Format setiap task:
```
- [ ] T-00X <judul singkat>
  - DoD: <kondisi yang bisa dicek atau dites>
  - Butuh: <T-00Y atau "-">
```

Hasilkan isi lengkap `docs/TASKS.md` (bagian Aktif berisi task berikutnya saja, sisanya di Backlog).
Jangan menulis kode.

Di akhir jawaban, tulis bagian **Langkah berikutnya**: task pertama yang dikerjakan,
dengan `prompts/04-plan-task.md`.
