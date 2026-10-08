## Tech Stack
- Bahasa: Go (modul `go.mod`)
- HTTP: `net/http` (ServeMux) atau chi
- Database: `database/sql` + driver (mis. pgx)
- Test: `go test` (table-driven)
- Lint: `go vet` + `gofmt`
- Scaffold awal: `go mod init <modul>`, lalu buat `cmd/app/main.go`

## Perintah Penting
Semua perintah lewat `make` (implementasinya di `Makefile`, jaga agar tetap sinkron dengan bagian ini):
- Setup (hook + dependency): `make setup`
- Install dependency saja: `make deps`
- Dev: `make dev`
- Test: `make test`
- Lint/format check: `make lint`
- Build: `make build`
- Sync salinan legacy (hanya jika `.ai-sync-targets` aktif): `make sync-ai`

## Struktur Proyek
```
cmd/app/main.go     entry point
internal/           kode privat aplikasi (handler, service, repo)
internal/**/*_test.go  test, berdampingan dengan paket
go.mod  go.sum
```

## Konvensi Stack
Stack: Go (HTTP service)
- Bungkus error dengan konteks: `fmt.Errorf("...: %w", err)`; jangan abaikan error.
- `context.Context` sebagai parameter pertama untuk operasi I/O.
- Hindari state global; kirim dependensi lewat konstruktor/struct.
- Format wajib `gofmt`; `make lint` gagal jika ada file belum terformat.
- Konfigurasi dari environment; jangan hardcode secret.
