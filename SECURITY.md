# Kebijakan Keamanan

Repo ini adalah template berisi script shell, git hook, dan workflow CI. Tidak ada layanan yang berjalan.

## Melaporkan kerentanan

Jangan membuka issue publik. Gunakan fitur **Security → Report a vulnerability** di halaman GitHub repo ini
(*private vulnerability reporting*). Sertakan langkah reproduksi dan dampaknya.

Yang termasuk cakupan, misalnya:

- script `scripts/` atau hook yang bisa dieksploitasi lewat nama file atau input yang dibuat khusus
- workflow CI yang bisa membocorkan secret atau memberi izin berlebih
- celah pada pemeriksaan `.env` di pre-commit hook

Laporan akan ditanggapi sebisanya oleh maintainer. Ini proyek pribadi, jadi tidak ada jaminan waktu respons.

## Catatan untuk pengguna template

- Hook pre-commit **bukan** pengaman penuh: bisa dilewati dengan `--no-verify`. Gunakan juga secret scanning di GitHub.
- Jangan pernah commit `.env`. Gunakan `.env.example` tanpa nilai asli.
- Tinjau sendiri kode yang dihasilkan AI sebelum merge. Instruksi di `AGENTS.md` tidak menjamin hasil yang aman.
