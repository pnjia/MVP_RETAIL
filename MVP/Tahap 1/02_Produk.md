# 02 — Produk

**Tahap:** 1 (MVP) · **Domain:** Master Data

## Tujuan
Mengelola katalog barang yang dijual. Produk adalah dasar dari POS, persediaan, dan laporan — tanpa data produk yang benar, modul lain tidak akurat.

## Ruang Lingkup
**Masuk MVP:**
- CRUD Produk
- Kategori produk
- Barcode
- SKU
- Harga jual (satu harga)

**Tidak masuk MVP (Tahap 1.5 — Harga):** multi-harga, harga grosir, diskon per produk, promo.

## Aktor & Hak Akses
| Aksi | Admin | Kasir |
|------|:-----:|:-----:|
| Lihat produk | ✅ | ✅ |
| Tambah/Edit/Hapus produk | ✅ | ❌ |
| Kelola kategori | ✅ | ❌ |

## Data Model

**categories**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| name | varchar UNIQUE | |
| description | text NULL | |
| deleted_at | timestamp NULL | soft delete |

**products**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| sku | varchar UNIQUE | Kode internal |
| barcode | varchar UNIQUE NULL | Kode scan (EAN/UPC) |
| name | varchar | |
| category_id | FK categories | |
| unit | varchar | pcs, kg, box |
| cost_price | decimal(15,2) | Harga modal (untuk laba) |
| sell_price | decimal(15,2) | Harga jual |
| is_active | boolean | |
| image_url | varchar NULL | |
| created_at/updated_at/deleted_at | timestamp | |

> Stok **tidak** disimpan di tabel produk — lihat modul `03_Persediaan`.

## Alur Kerja

**Tambah Produk**
1. Admin isi: nama, SKU, kategori, harga modal, harga jual, satuan, barcode (opsional).
2. Sistem validasi SKU/barcode unik.
3. Simpan produk → stok awal 0 (atau diisi via Penyesuaian Stok).

**Cari Produk (dipakai POS)**
- Cari by nama, SKU, atau barcode. Barcode = exact match; nama = partial/LIKE.

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| GET | `/products?search=&category=&page=` | List + filter |
| GET | `/products/{id}` | Detail |
| GET | `/products/barcode/{code}` | Lookup cepat untuk scan |
| POST | `/products` | Buat (Admin) |
| PUT | `/products/{id}` | Update (Admin) |
| DELETE | `/products/{id}` | Soft delete (Admin) |
| GET/POST/PUT/DELETE | `/categories` | CRUD kategori |

## Aturan Bisnis
- SKU wajib & unik. Barcode unik bila diisi.
- `sell_price ≥ 0`; idealnya `sell_price ≥ cost_price` (beri peringatan, jangan blok).
- Hapus = soft delete. Produk yang pernah dipakai transaksi **tidak boleh** hilang dari riwayat.
- Produk nonaktif tidak muncul di pencarian POS, tapi tetap di laporan lama.

## Validasi & Edge Case
- Scan barcode tidak ditemukan → tawarkan buat produk baru (Admin) atau tolak (Kasir).
- Edit harga tidak mengubah harga transaksi yang sudah terjadi (harga disalin saat transaksi).
- Hapus kategori yang masih punya produk → tolak / minta pindahkan dulu.

## Acceptance Criteria
- [ ] Admin bisa CRUD produk & kategori.
- [ ] Scan barcode menemukan produk < 300ms.
- [ ] SKU/barcode duplikat ditolak.
- [ ] Produk terhapus tidak merusak riwayat transaksi.

## Dependensi
- `01_Authentication` (hak akses).
- Dipakai oleh: `03_Persediaan`, `04_POS`, `08_Laporan`.
