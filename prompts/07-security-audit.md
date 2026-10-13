<!-- Tahap 4 (task sensitif) dan wajib sebelum Tahap 5 rilis (lihat docs/ROADMAP.md). -->
Audit keamanan kode ini berdasarkan OWASP Top 10: injeksi, auth/otorisasi rusak, secret ter-hardcode,
validasi input, rate limiting, CORS, upload file, logging data sensitif, dependency rentan atau tidak ada.
Cek juga aturan di bagian "Keamanan" pada `AGENTS.md`.

Format temuan, urut dari paling parah:
```
[KRITIS|TINGGI|SEDANG|RENDAH] file:baris — temuan — skenario serangan singkat — perbaikan konkret
```

Jangan mengubah kode. Jika sebuah kategori tidak relevan (mis. tidak ada upload), sebutkan singkat.

Di akhir jawaban, tulis bagian **Langkah berikutnya**: temuan mana yang wajib diperbaiki sebelum rilis,
dan tulis masing-masing sebagai task baru untuk `docs/TASKS.md`.
