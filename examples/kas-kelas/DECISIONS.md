# Catatan Keputusan — Kas Kelas

## 0001 — Tanpa backend, data di localStorage
- Tanggal: 2026-10-10
- Status: diterima
- Konteks: PRD hanya punya satu pengguna di satu perangkat, data < 100 KB, dan nama siswa tidak boleh dikirim ke server.
- Keputusan: aplikasi frontend saja (React), data di `localStorage`, cadangan lewat ekspor/impor JSON.
- Alasan: tidak ada server untuk dirawat atau diamankan, hosting gratis, bisa dipakai offline.
- Alternatif ditolak: SvelteKit + SQLite (butuh server dan login untuk hal yang belum dibutuhkan);
  Google Sheets sebagai database (butuh login Google dan API key, menambah kerumitan).
- Konsekuensi: data hilang jika cache browser dibersihkan → wajib ada fitur cadangan dan pengingatnya.
  Jika nanti butuh banyak perangkat, perlu backend; ganti keputusan ini dengan entri baru.

## 0002 — Minggu dicatat dengan format ISO week
- Tanggal: 2026-10-12
- Status: diterima
- Konteks: pembayaran dicatat per minggu; perlu kunci yang tidak ambigu lintas bulan dan tahun.
- Keputusan: simpan minggu sebagai string ISO week, mis. `2026-W41`.
- Alasan: urutan bisa dibandingkan sebagai string, tidak tergantung zona waktu atau nama bulan.
- Alternatif ditolak: tanggal hari Senin (rawan salah di zona waktu), nomor minggu ke-N semester (ambigu antar semester).
- Konsekuensi: perlu satu fungsi konversi tanggal → ISO week yang dites dengan baik (pergantian tahun).
