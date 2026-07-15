# Tasks Specification: Product Variants & Price History (11-product-variants)

## 1. Overview
Rencana kerja ini mengimplementasikan dua tabel baru `product_variants` dan `product_prices` sebagai pelengkap final modul katalog produk MangRitel yang belum diimplementasikan di Supabase.

## 2. Task List

### Tahap 1: Pembuatan Tabel Product Variants
- [x] 1.1 Buat tabel `product_variants`.
  - Implementasikan tabel (id, uuid, product_id FK, name, sku, barcode, price DECIMAL(15,2), cost DECIMAL(15,2), is_active, audit standar).
  - Buat indeks pada `product_id` dan `sku` parsial aktif.
  - Aktifkan RLS pada `product_variants`.
  - _Requirements: REQ-1_

### Tahap 2: Pembuatan Tabel Product Prices (Riwayat Harga)
- [x] 2.1 Buat tabel `product_prices`.
  - Implementasikan tabel (id, product_id FK, variant_id FK nullable, price, cost, effective_date, end_date, audit standar).
  - Buat indeks parsial `idx_product_prices_active` untuk lookup harga aktif per produk.
  - Aktifkan RLS pada `product_prices`.
  - _Requirements: REQ-2_

### Tahap 3: Konfigurasi Kebijakan RLS
- [x] 3.1 Terapkan policies RLS pada `product_variants`.
  - Buat policy SELECT/INSERT/UPDATE/DELETE berbasis join ke `products.outlet_id` menggunakan `public.user_has_outlet_access()`.
  - _Requirements: REQ-3_
- [x] 3.2 Terapkan policies RLS pada `product_prices`.
  - Buat policy SELECT/INSERT/UPDATE/DELETE berbasis join ke `products.outlet_id`.
  - _Requirements: REQ-3_

## 3. Quality Gates
- [x] Tabel `product_variants` dan `product_prices` sukses dibuat di Supabase.
- [x] Foreign key dari `product_variants.product_id` ke `products(id)` dan dari `product_prices.variant_id` ke `product_variants(id)` terpasang dengan benar.
- [x] RLS policies terapkan isolasi data per-outlet melalui join ke `products`.
