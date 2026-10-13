# PRD — Kas Kelas

## 1. Masalah
Bendahara kelas mencatat iuran kas mingguan di buku tulis. Setiap akhir bulan ia harus menghitung ulang
siapa yang belum bayar, sering salah, dan sulit menunjukkan bukti saat ada siswa yang protes.

## 2. Target User
Satu bendahara kelas SMA (siswa), memakai HP Android, terbiasa WhatsApp dan Google Docs, bukan orang teknis.
Dipakai di kelas atau di rumah, 2-3 kali seminggu.

## 3. Tujuan & Metrik Sukses
- Bendahara bisa mencatat satu pembayaran dalam < 30 detik.
- Bendahara bisa melihat daftar siswa yang belum bayar minggu ini dalam 1 layar, tanpa menghitung manual.
- Selama 1 bulan pemakaian, tidak ada selisih antara catatan aplikasi dan uang di tangan.

## 4. User Stories
- Sebagai bendahara, saya ingin memasukkan daftar siswa sekali saja, supaya tidak mengetik ulang tiap minggu.
- Sebagai bendahara, saya ingin menandai siswa yang membayar minggu ini dengan sekali ketuk.
- Sebagai bendahara, saya ingin melihat siapa yang menunggak dan berapa minggu, supaya bisa menagih.
- Sebagai bendahara, saya ingin melihat total saldo kas, supaya bisa melapor ke wali kelas.
- Sebagai bendahara, saya ingin menyimpan cadangan data, supaya tidak hilang jika HP rusak.

## 5. Scope MVP
**Masuk:**
- [ ] Kelola daftar siswa (tambah, ubah nama, nonaktifkan)
- [ ] Tandai pembayaran per minggu (nominal iuran tetap)
- [ ] Daftar tunggakan: siswa + jumlah minggu belum bayar
- [ ] Saldo kas (pemasukan dikurangi pengeluaran yang dicatat manual)
- [ ] Ekspor/impor cadangan data (file JSON)

**TIDAK masuk (sengaja ditunda):**
- Laporan PDF untuk wali kelas (cukup screenshot dulu)
- Pengingat otomatis ke WhatsApp siswa
- Banyak kelas / banyak bendahara dalam satu aplikasi
- Login dan sinkronisasi antar perangkat

## 6. Alur Utama
1. Pertama kali: bendahara mengisi nominal iuran mingguan dan menempel daftar nama siswa.
2. Setiap ada yang bayar: buka minggu ini, ketuk nama siswa → tercatat lunas.
3. Akhir minggu: buka "Tunggakan", lihat siapa yang belum bayar, tagih.
4. Sebulan sekali: ekspor cadangan data, simpan di Google Drive.

## 7. Non-Functional
- Nyaman dipakai di layar HP (lebar 360px).
- Bisa dipakai tanpa internet setelah dibuka pertama kali.
- Data nama siswa tidak dikirim ke server mana pun.
- Maksimal ~40 siswa, ~40 minggu per tahun ajaran.

## 8. Risiko & Pertanyaan Terbuka
- Data tersimpan di browser HP; jika cache dibersihkan, data hilang. Mitigasi: pengingat ekspor cadangan.
- Bagaimana jika nominal iuran berubah di tengah semester? → MVP: nominal tetap, perubahan ditunda.
