# 04 — Harga (Pricing & Promo)

**Tahap:** 1.5 · **Domain:** Master Data / Pricing

## Tujuan
Memperluas harga tunggal (Tahap 1) menjadi multi-harga, diskon, dan promo agar mendukung grosir, member, dan kampanye penjualan.

## Ruang Lingkup
- **Multi Harga** — harga berbeda per tipe (eceran, grosir, member) atau per rentang qty (tiered).
- **Diskon** — per produk / per kategori / per transaksi.
- **Promo** — aturan berlaku pada periode tertentu (mis. beli 2 gratis 1, potongan %).

## Data Model

**price_levels**
| Field | Tipe |
|-------|------|
| id / name | retail, grosir, member |

**product_prices**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| product_id | FK | |
| price_level_id | FK | |
| min_qty | int | harga berlaku mulai qty ini (tiered) |
| price | decimal | |

**promotions**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| name | varchar | |
| type | enum('percent','amount','buy_x_get_y') | |
| scope | enum('product','category','transaction') | |
| target_id | bigint NULL | id produk/kategori |
| value | decimal | % atau nominal |
| min_purchase | decimal NULL | syarat minimal |
| start_at / end_at | timestamp | |
| is_active | boolean | |

## Alur Kerja (di POS)
1. Saat item masuk keranjang, tentukan harga dasar:
   - pilih `price_level` pelanggan (default retail),
   - cek `product_prices` dengan `min_qty` tertinggi yang ≤ qty (tiered).
2. Terapkan promo aktif yang cocok (produk/kategori), lalu promo transaksi.
3. Tampilkan harga & diskon transparan di keranjang dan struk.

## Aturan Bisnis
- Urutan penerapan ditetapkan & konsisten (harga dasar → diskon item → promo → diskon transaksi).
- Promo hanya berlaku dalam `start_at`–`end_at` dan saat `is_active`.
- Tidak boleh menghasilkan harga/total negatif.
- Harga final tetap di-snapshot ke `order_items` (lihat Tahap 1/04_POS).

## Acceptance Criteria
- [ ] Satu produk bisa punya beberapa harga (level & tiered).
- [ ] Promo periode berjalan otomatis aktif/nonaktif by tanggal.
- [ ] Perhitungan diskon transparan & tidak menghasilkan nilai negatif.

## Dependensi
- `Tahap 1/02_Produk`, `Tahap 1/04_POS`, `Tahap 1/06_Pelanggan` (price level member).
