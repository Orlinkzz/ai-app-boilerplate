# Daftar Task

Aturan: satu task = satu sesi AI = satu commit/PR kecil.
Setiap task punya Definition of Done (DoD) yang bisa dites.
Isi daftar ini dengan `prompts/03-break-into-tasks.md` setelah PRD dan arsitektur selesai (lihat `docs/ROADMAP.md`).

## Aktif
- [ ] T-001 Setup project: isi target di Makefile (setup/dev/test/lint/build), setup runtime di .github/workflows/ci.yml
  - DoD: `make lint` dan `make test` hijau lokal dan di CI
  - Butuh: stack sudah dipilih dan diterapkan (lihat `make stacks`)

## Backlog
- [ ] T-002 <alur utama paling sederhana dari ujung ke ujung, diambil dari PRD>
  - DoD: <kondisi yang bisa dicek atau dites>
  - Butuh: T-001

## Selesai
