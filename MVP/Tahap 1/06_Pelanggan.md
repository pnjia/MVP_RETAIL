# 06 — Pelanggan (Customer)

**Tahap:** 1 (MVP) · **Domain:** Master Data

## Tujuan
Menyimpan data pelanggan dan riwayat belanjanya. Dasar untuk fitur lanjutan (kredit/piutang di Tahap 2, loyalty di Enterprise).

## Ruang Lingkup
**Masuk MVP:**
- CRUD pelanggan
- Riwayat pembelian per pelanggan

**Tidak masuk MVP:** poin loyalty, membership, kredit (Tahap 2 & Enterprise).

## Aktor & Hak Akses
| Aksi | Admin | Kasir |
|------|:-----:|:-----:|
| Lihat & cari pelanggan | ✅ | ✅ |
| Tambah pelanggan | ✅ | ✅ |
| Edit/Hapus | ✅ | ❌ |

## Data Model

**customers**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| code | varchar UNIQUE NULL | kode member opsional |
| name | varchar | |
| phone | varchar NULL | sebaiknya unik |
| email | varchar NULL | |
| address | text NULL | |
| note | text NULL | |
| created_at/updated_at/deleted_at | timestamp | |

> Riwayat pembelian = query ke `orders WHERE customer_id = ?`. Tidak butuh tabel baru.

## Alur Kerja
**Tambah saat transaksi:** di POS, kasir bisa pilih pelanggan atau buat cepat (nama + HP) lalu lanjut bayar.

**Riwayat:** buka detail pelanggan → daftar order (tanggal, invoice, total), ringkasan total belanja & frekuensi.

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| GET | `/customers?search=` | List/cari |
| GET | `/customers/{id}` | Detail |
| GET | `/customers/{id}/orders` | Riwayat pembelian |
| POST | `/customers` | Buat |
| PUT | `/customers/{id}` | Update (Admin) |
| DELETE | `/customers/{id}` | Soft delete (Admin) |

## Aturan Bisnis
- Pelanggan opsional di transaksi (default walk-in / null).
- Nomor HP sebaiknya unik untuk cegah duplikat.
- Soft delete; pelanggan yang punya riwayat tidak dihapus permanen.

## Validasi & Edge Case
- Buat pelanggan dengan HP yang sudah ada → tawarkan pakai yang lama.
- Hapus pelanggan tidak menghapus order-nya (customer_id tetap ada sebagai snapshot atau null + nama tersimpan di order).

## Acceptance Criteria
- [ ] CRUD pelanggan berfungsi.
- [ ] Bisa pilih/buat pelanggan langsung di POS.
- [ ] Riwayat pembelian per pelanggan tampil benar.

## Dependensi
- `01_Authentication`. Terhubung ke `04_POS`.
