<!-- Tahap 5 (lihat docs/ROADMAP.md). Pakai setelah semua task MVP selesai dan audit keamanan beres. -->
Aplikasi saya sudah jalan di lokal dan semua task MVP di `docs/TASKS.md` selesai. Bantu saya merilisnya.
Baca `AGENTS.md`, `docs/ARCHITECTURE.md` (bagian Deployment), dan konfigurasi proyek.

Konteks: budget hosting <mis. gratis / maks Rp100rb per bulan>, domain <punya / belum>.

Yang saya minta:
1. Dua opsi hosting yang cocok untuk stack ini, dengan trade-off (biaya, kemudahan, batas paket gratis).
   Sebutkan bahwa harga dan batas paket harus saya cek ulang di situs resminya.
2. Langkah deploy untuk opsi yang direkomendasikan, sebagai checklist yang bisa saya ikuti.
3. Daftar environment variable yang dibutuhkan di production (nama saja, JANGAN nilai rahasianya).
4. Checklist sebelum rilis: build production lolos, secret tidak ada di repo, HTTPS, backup database
   (jika ada), halaman error, cara rollback.
5. Usulan entri `docs/DECISIONS.md` dan isi bagian Deployment di `docs/ARCHITECTURE.md`.

Jangan mengubah konfigurasi CI/CD atau file `.env*` tanpa izin saya.

Di akhir jawaban, tulis bagian **Langkah berikutnya**: cara memastikan aplikasi benar-benar bisa dipakai
orang lain, lalu `prompts/10-iterate.md` setelah ada pengguna.
