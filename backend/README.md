# Backend — REST API UMKM (CodeIgniter 4)

REST API CRUD data UMKM untuk tugas **Topic 10 – REST API & JSON Parsing**.
Dibangun dengan CodeIgniter 4 (v4.7) + MySQL. Dikonsumsi oleh aplikasi Flutter di folder `../frontend`.

## Menjalankan

Prasyarat: PHP 8.2+ (ekstensi `intl`, `mbstring`, `mysqli`), Composer, MySQL/MariaDB (XAMPP juga bisa).

```bash
cd backend
composer install                     # pasang dependensi (laminas-escaper, psr/log)
cp env .env                          # Windows: copy env .env
```

Edit `.env` (hapus tanda `#` di depan baris berikut dan sesuaikan):

```ini
CI_ENVIRONMENT = development
app.baseURL = 'http://localhost:8080/'

database.default.hostname = localhost
database.default.database = db_umkm
database.default.username = root
database.default.password =          # XAMPP: kosong
database.default.DBDriver = MySQLi
database.default.port = 3306
```

Buat database + tabel + data contoh:

```bash
mysql -u root -p < database/umkm.sql
```

Jalankan server (agar bisa diakses emulator Android / HP di jaringan yang sama, pakai `--host 0.0.0.0`):

```bash
php spark serve --host 0.0.0.0 --port 8080
```

Base URL: `http://localhost:8080/api`
(Emulator Android mengakses laptop lewat `http://10.0.2.2:8080/api`.)

## Endpoint

| Method | URL                | Keterangan                                              | Status sukses |
|--------|--------------------|---------------------------------------------------------|---------------|
| GET    | `/api/umkm`        | Daftar UMKM. Query: `page`, `per_page`, `q`, `kategori` | 200           |
| GET    | `/api/umkm/{id}`   | Detail satu UMKM                                        | 200           |
| POST   | `/api/umkm`        | Tambah UMKM                                             | 201           |
| PUT    | `/api/umkm/{id}`   | Ubah UMKM (semua field wajib dikirim)                   | 200           |
| DELETE | `/api/umkm/{id}`   | Hapus UMKM                                              | 200           |

Body POST/PUT (JSON, `Content-Type: application/json`; `x-www-form-urlencoded` juga didukung):

```json
{
  "nama_umkm": "Kopi Nusantara",
  "pemilik": "Rafi A",
  "alamat": "Jl. Ayani No. 10, Banjarbaru",
  "kategori": "Kuliner",
  "kontak": "08123456789"
}
```

Kategori valid: `Kuliner`, `Fashion`, `Kerajinan`, `Jasa`, `Pertanian`, `Perdagangan`, `Lainnya`.

### Format response

Sukses:

```json
{ "success": true, "message": "Data UMKM berhasil diambil", "data": [ ... ], "meta": { "page": 1, "per_page": 10, "total": 5, "total_pages": 1 } }
```

Gagal (400 validasi / 404 tidak ditemukan / 500 error server):

```json
{ "success": false, "message": "Gagal menambahkan data UMKM", "errors": { "nama_umkm": "Nama UMKM wajib diisi" } }
```

## Struktur kode

```
app/
├── Controllers/Api/UmkmController.php   # logika CRUD + format response
├── Models/UmkmModel.php                 # tabel, allowedFields, aturan validasi
└── Config/
    ├── Routes.php                       # route /api/umkm
    ├── Filters.php                      # filter CORS untuk /api/*
    └── Cors.php                         # izin origin/method (Flutter Web)
database/umkm.sql                        # skema + data contoh
```

> Catatan: `Cors.php` saat ini mengizinkan semua origin (`*`) untuk kemudahan pengembangan.
> Batasi ke domain tertentu jika API dipublikasikan.
