# Tasks Specification: Inventory Core (04-inventory-core)

## 1. Overview
Rencana kerja ini mengimplementasikan pembaruan Modul Inventaris dari baseline Mangkasir ke MangRitel. Tahap pengerjaan mencakup penambahan master data gudang baru, pembaruan tipe data presisi desimal untuk stok, pembuatan tabel ledger pergerakan stok, dan sinkronisasi otomatis menggunakan trigger database.

## 2. Task List

### Tahap 1: Pembuatan Tabel Gudang Baru (warehouses)
- [x] 1.1 Buat tabel `warehouses`.
  - Implementasikan tabel `warehouses` (id, uuid, outlet_id, name, location, is_default, audit standar).
  - Tambahkan Foreign Key ke `outlets(id)` ON DELETE CASCADE.
  - Aktifkan RLS pada `warehouses`.
  - _Requirements: REQ-1_
- [x] 1.2 Buat fungsi trigger untuk menetapkan gudang default per outlet.
  - Buat fungsi database `public.set_default_warehouse_func()`. Jika gudang baru di-insert dan merupakan gudang pertama untuk outlet tersebut, atau jika di-insert dengan `is_default = TRUE`, matikan `is_default` pada gudang lain di outlet yang sama.
  - Pasang trigger `trg_set_default_warehouse` pada tabel `warehouses`.
  - _Requirements: REQ-1_
- [x] 1.3 Lakukan seeding untuk membuat minimal 1 gudang default per outlet yang ada.
  - Tulis kueri DML untuk membuat gudang default ("Gudang Utama") untuk setiap outlet yang terdaftar di database.
  - _Requirements: REQ-1_

### Tahap 2: Migrasi Struktur Stock In, Stock Out, dan Stocks
- [x] 2.1 Modifikasi dan sesuaikan tabel `stock_in_headers` dan `stock_in_details`.
  - Putuskan foreign key lama pada tabel detail.
  - Rename kolom store_id -> outlet_id, dan kolom audit ke snake_case pada header.
  - Tambahkan `uuid`, `deleted_at`, `goods_receipt_id` pada header.
  - Ubah tipe data `product_guid` ke UUID, `qty` ke DECIMAL(18,4), `cost` ke DECIMAL(15,2) pada detail.
  - Hubungkan kembali Foreign Key constraints.
  - _Requirements: REQ-3_
- [x] 2.2 Modifikasi dan sesuaikan tabel `stocks`.
  - Putuskan foreign key lama `FKdijuytuiujr2wsyfno5o631oo`.
  - Ubah tipe data `product_guid` ke UUID, `qty` ke DECIMAL(18,4).
  - Tambahkan kolom `warehouse_id` dan `deleted_at`.
  - Petakan `warehouse_id` ke ID gudang default outlet terkait.
  - Hubungkan kembali constraints `FKdijuytuiujr2wsyfno5o631oo` dan `fk_stocks_product` ke `products(uuid)`.
  - _Requirements: REQ-2_
- [x] 2.3 Modifikasi dan sesuaikan tabel `stock_out_headers` dan `stock_out_details`.
  - Putuskan foreign key lama.
  - Rename store_id -> outlet_id pada header, dan sesuaikan kolom audit ke snake_case.
  - Ubah tipe data `product_guid` ke UUID, `qty` ke DECIMAL(18,4), dan `cost` ke DECIMAL(15,2) pada detail.
  - Hubungkan kembali Foreign Key constraints.
  - _Requirements: REQ-4_

### Tahap 3: Pembuatan Ledger dan Logika Sinkronisasi Stok Otomatis
- [x] 3.1 Buat tabel `stock_movements`.
  - Implementasikan tabel `stock_movements` (id, stock_id, product_guid, warehouse_id, movement_type, qty, reference_type, reference_id, balance_after, created_at, created_by).
  - Tambahkan Foreign Key ke `stocks(id)`, `products(uuid)`, dan `warehouses(id)`.
  - Aktifkan RLS pada `stock_movements`.
  - _Requirements: REQ-5_
- [x] 3.2 Buat fungsi trigger `public.sync_stock_ledger_projection_func()`.
  - Buat fungsi database untuk memperbarui `stocks.qty` and `products.qty` setiap kali baris pergerakan stok ditambahkan ke `stock_movements`.
  - Jika pergerakan bertipe 'in' maka tambahkan nilai qty, jika bertipe 'out' atau yang lain maka kurangi.
  - Pasang trigger `trg_sync_stock_ledger` AFTER INSERT pada `stock_movements`.
  - _Requirements: REQ-5_

### Tahap 4: Konfigurasi Kebijakan RLS (Row Level Security)
- [x] 4.1 Terapkan kebijakan akses RLS modul inventaris.
  - Buat policy untuk `warehouses`, `stock_in_headers`, `stock_out_headers` berbasis `public.user_has_outlet_access(outlet_id)`.
  - Buat policy untuk `stocks`, `stock_in_details`, `stock_out_details`, dan `stock_movements` berbasis join query atau subquery yang mencocokkan `outlet_id` cabang terkait.
  - _Requirements: REQ-6_

## 3. Quality Gates
- [x] Tabel `warehouses` dan `stock_movements` aktif di database.
- [x] Skema tabel `stocks`, `stock_in_details`, `stock_out_details` sukses bertransformasi mendukung kuantitas desimal.
- [x] Trigger otomatis pergerakan stok berhasil menyinkronkan total kuantitas di tabel `stocks` dan `products`.
- [x] RLS membatasi seluruh aktivitas stok agar terisolasi per-cabang.
