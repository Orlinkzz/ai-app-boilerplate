# Arsitektur — Kas Kelas

## Status
- Stack dipilih: react (`make init STACK=react`)

## Gambaran Umum
Aplikasi frontend saja (single-page app), tanpa backend. Semua data disimpan di `localStorage` browser
melalui satu modul penyimpanan. Cadangan data berupa file JSON yang diunduh/diunggah pengguna.

```
[UI React] → [hooks: useKas] → [lib/storage.ts] → localStorage
                                    ↕
                          ekspor/impor file JSON
```

## Tech Stack & Alasan
| Layer | Pilihan | Alasan |
|---|---|---|
| Frontend | React + TypeScript (Vite) | Template `react` sudah teruji; banyak contoh untuk dipelajari |
| Penyimpanan | `localStorage` | Satu pengguna, satu perangkat, data kecil (< 100 KB). Lihat DECISIONS 0001 |
| Test | Vitest + Testing Library | Bawaan konvensi stack `react` |
| Hosting | Situs statis | Gratis, tidak ada server untuk dirawat |

## Struktur Folder
```
src/components/   DaftarSiswa, MingguIni, Tunggakan, Saldo, Cadangan
src/hooks/        useKas.ts (state + aksi)
src/lib/          storage.ts (baca/tulis + validasi), hitung.ts (tunggakan, saldo)
src/**/*.test.ts  test
```

## Skema Data
```ts
type Data = {
  versi: 1
  iuranPerMinggu: number            // rupiah, bilangan bulat > 0
  siswa: { id: string; nama: string; aktif: boolean }[]
  bayar: { siswaId: string; minggu: string }[]          // minggu format ISO "2026-W41"
  pengeluaran: { id: string; tanggal: string; nominal: number; ket: string }[]
}
```

## API
Tidak ada (tanpa backend).

## Auth & Otorisasi
Tidak perlu di MVP: satu pengguna di perangkatnya sendiri.

## Integrasi Eksternal
Tidak ada.

## Deployment
Build statis (`make build`) ke hosting situs statis. Rollback: deploy ulang commit sebelumnya.
