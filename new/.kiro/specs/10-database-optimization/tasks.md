# Tasks Specification: Database Optimization (10-database-optimization)

## 1. Overview
Rencana kerja ini mengimplementasikan pengaktifan ekstensi trigram pencarian, pembuatan indeks pencarian cepat produk, indeks optimasi performa laporan/ledger, serta view pembantu validasi impor produk massal di Supabase MangRitel.

## 2. Task List

### Tahap 1: Aktifkan Ekstensi & Indeks Trigram Pencarian
- [x] 1.1 Aktifkan extension trigram di database.
  - Jalankan kueri `CREATE EXTENSION IF NOT EXISTS pg_trgm;` di Supabase.
  - _Requirements: REQ-1_
- [x] 1.2 Buat indeks GIN trigram pada kolom produk.
  - Buat indeks `idx_products_name_trgm` pada `products(name USING gin_trgm_ops)`.
  - Buat indeks `idx_products_sku_trgm` pada `products(sku USING gin_trgm_ops)`.
  - _Requirements: REQ-1_
- [x] 1.3 Buat indeks pencarian barcode produk.
  - Buat indeks `idx_products_barcode` Btree parsial untuk barcode produk non-kosong.
  - _Requirements: REQ-1_

### Tahap 2: Indeks Performa Transaksi & Ledger Stok
- [x] 2.1 Buat indeks laporan transaksi POS.
  - Buat indeks komposit `idx_transactions_perf` pada `transactions(outlet_id, date, flag)` parsial `deleted_at IS NULL`.
  - Buat indeks komposit `idx_transaction_details_perf` pada `transaction_details(transaction_guid, product_guid)`.
  - _Requirements: REQ-2_
- [x] 2.2 Buat indeks histori ledger kartu stok.
  - Buat indeks komposit kronologis `idx_stock_movements_perf` pada `stock_movements(product_guid, warehouse_id, created_at DESC)`.
  - _Requirements: REQ-2_

### Tahap 3: Pembuatan View Helper Impor Data Produk
- [x] 3.1 Buat database view `view_product_import_helper`.
  - Implementasikan view validasi format produk CSV/Excel impor (pemetaan outlet, kategori, brand, unit, dan status pesan error jika tidak valid).
  - _Requirements: REQ-3_

## 3. Quality Gates
- [x] Ekstensi `pg_trgm` aktif di Supabase.
- [x] Indeks trigram `GIN` dan indeks komposit laporan sukses terbuat di database.
- [x] View `view_product_import_helper` berhasil dikompilasi tanpa error reference.
