# Tasks Specification: Product Catalog & Master Data (product-catalog)

## 1. Overview
Rencana kerja ini mengimplementasikan pembaruan katalog produk dari skema legacy Mangkasir ke skema MangRitel/Eqiozmart secara bertahap. Alur kerja difokuskan pada pembersihan tipe data, ekstraksi satuan teks ke master data relasional, pembuatan tabel varian & riwayat harga, serta proteksi data menggunakan RLS.

## 2. Task List

### Tahap 1: Restrukturisasi Tabel Kategori, Brand, dan Unit
- [x] 1.1 Migrasikan tabel kategori.
  - Rename tabel `product_cats` menjadi `categories`.
  - Rename kolom `name` menjadi `category_name`.
  - Tambah kolom `uuid` (UUID) default `gen_random_uuid()` unique, dan kolom `deleted_at`.
  - _Requirements: REQ-1_
- [x] 1.2 Buat tabel master data `brands`.
  - Buat tabel `brands` (id, uuid, business_id, name, audit standar).
  - Tambahkan Unique constraint `(business_id, name)`.
  - Aktifkan RLS pada `brands`.
  - _Requirements: REQ-2_
- [x] 1.3 Buat tabel master data `units`.
  - Buat tabel `units` (id, uuid, business_id, name, abbreviation, audit standar).
  - Tambahkan Unique constraint `(business_id, abbreviation)`.
  - Aktifkan RLS pada `units`.
  - _Requirements: REQ-3_

### Tahap 2: Ekstraksi Data Satuan Legacy & Modifikasi Skema Produk
- [x] 2.1 Ekstrak satuan teks produk lama menjadi master data `units`.
  - Tulis kueri DML untuk membaca nilai unik kolom `products.unit` legacy yang ada di database.
  - Masukkan nilai-nilai unik tersebut sebagai record baru di tabel `units`, secara otomatis dihubungkan ke ID default business (`business_id = 1`).
  - _Requirements: REQ-3_
- [x] 2.2 Modifikasi kolom pada tabel `products` legacy.
  - Rename kolom `guid` menjadi `uuid`.
  - Tambahkan kolom foreign key `brand_id` ke tabel `brands` dan `unit_id` ke tabel `units`.
  - Tambahkan kolom `deleted_at` TIMESTAMPTZ.
  - Ubah tipe data kolom: `cost` menjadi `DECIMAL(15,2)`, `price` menjadi `DECIMAL(15,2)`, dan `qty` menjadi `DECIMAL(18,4)`.
  - _Requirements: REQ-4_
- [x] 2.3 Petakan satuan produk lama ke `unit_id` baru dan bersihkan kolom lama.
  - Tulis kueri UPDATE untuk mengisi `products.unit_id` berdasarkan pencocokan teks `products.unit` legacy dengan `units.name`.
  - Hapus kolom `unit` (varchar) legacy dari tabel `products`.
  - Tambahkan UNIQUE constraint `(outlet_id, sku)` ke tabel `products`.
  - _Requirements: REQ-3, REQ-4_

### Tahap 3: Implementasi Tabel Varian & Riwayat Harga
- [x] 3.1 Buat tabel `product_variants`.
  - Buat tabel `product_variants` (id, uuid, product_id, name, sku, barcode, price, cost, audit standar).
  - Aktifkan RLS pada `product_variants`.
  - _Requirements: REQ-5_
- [x] 3.2 Buat tabel `product_prices`.
  - Buat tabel `product_prices` (id, product_id, variant_id, price, cost, effective_date, end_date, created_at).
  - Aktifkan RLS pada `product_prices`.
  - _Requirements: REQ-6_
- [x] 3.3 Buat trigger otomatis untuk mencatat perubahan harga.
  - Buat fungsi database `public.sync_price_history_func()`. Fungsi ini akan mendeteksi setiap insert/update harga pada tabel `products` atau `product_variants`.
  - Jika harga/cost berubah, masukkan record baru ke `product_prices` dengan `effective_date = CURRENT_DATE` dan perbarui `end_date = CURRENT_DATE - 1` pada record harga terlama yang aktif.
  - Pasang trigger `trg_sync_product_price` pada `products` dan `trg_sync_variant_price` pada `product_variants`.
  - _Requirements: REQ-6_

### Tahap 4: Konfigurasi RLS Policies Modul Product
- [x] 4.1 Terapkan kebijakan akses RLS pada tabel-tabel Modul Product.
  - Buat policy SELECT/INSERT/UPDATE/DELETE untuk `brands` dan `units` berbasis `business_id = get_auth_business_id()`.
  - Buat policy SELECT/INSERT/UPDATE/DELETE untuk `categories`, `products`, `product_variants`, dan `product_prices` berbasis `outlet_id` user (diambil dari subquery relasi `user_has_outlet`).
  - _Requirements: REQ-6_

## 3. Quality Gates
- [ ] Tabel `categories`, `brands`, `units`, `products`, `product_variants`, dan `product_prices` aktif di Supabase.
- [ ] Seluruh data teks `unit` produk lama sukses dimigrasikan ke foreign key `unit_id` tanpa ada data produk yang hilang.
- [ ] Trigger histori harga berhasil mencatat baris baru di `product_prices` saat harga produk diubah di tabel `products`.
- [ ] RLS mencegah mutasi atau pembacaan katalog produk lintas outlet/bisnis yang berbeda.
