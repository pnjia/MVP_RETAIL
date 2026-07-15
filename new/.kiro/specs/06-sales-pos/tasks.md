# Tasks Specification: Sales POS (06-sales-pos)

## 1. Overview
Rencana kerja ini mendokumentasikan langkah-langkah pembaruan tabel penjualan Mangkasir lama ke MangRitel dan pembuatan sistem retur penjualan baru. Tahap pengerjaan fokus pada konversi data type, penegasan constraints, serta otomatisasi jurnal ledger pengurang stok POS & jurnal pembalik void POS menggunakan database triggers di Supabase.

## 2. Task List

### Tahap 1: Modifikasi Skema Tabel Penjualan Legacy
- [x] 1.1 Modifikasi dan sesuaikan tabel `transactions`.
  - Putuskan foreign key lama yang menunjuk ke tabel ini.
  - Rename kolom store_id -> outlet_id, dan sesuaikan kolom audit menjadi snake_case.
  - Tambahkan kolom `cashier_id` (BIGINT REFERENCES users(id)) dan `deleted_at`.
  - Ubah tipe data `sub_total`, `invoice_discount`, `invoice_ppn` ke DECIMAL(15,2).
  - Konversi status data boolean `deleted` ke `deleted_at`.
  - Re-create unique constraints `uk_transactions_guid` dan `uk_transactions_invoice`.
  - _Requirements: REQ-1_
- [x] 1.2 Modifikasi dan sesuaikan tabel `transaction_details`.
  - Putuskan constraints lama.
  - Ubah tipe data `product_guid` ke UUID.
  - Ubah tipe data `qty` ke DECIMAL(18,4), dan kolom moneter (`price`, `discount`, `ppn`, `total_price`, `cost` HPP) ke DECIMAL(15,2).
  - Sesuaikan kolom audit ke snake_case, tambahkan `deleted_at`, konversi `deleted` boolean ke `deleted_at`.
  - Pasang Foreign Key ke `transactions(guid)`, `products(uuid)`, dan `stocks(id)`.
  - _Requirements: REQ-2_
- [x] 1.3 Modifikasi dan sesuaikan tabel `payments`.
  - Putuskan constraints lama.
  - Ubah tipe data kolom moneter (`sub_total`, `paid`, `change_amount`) ke DECIMAL(15,2).
  - Sesuaikan kolom audit ke snake_case, tambahkan `deleted_at`, konversi `deleted` boolean ke `deleted_at`.
  - Pasang Foreign Key ke `transactions(guid)`.
  - _Requirements: REQ-3_

### Tahap 2: Pembuatan Tabel Sales Returns (SR) Baru
- [x] 2.1 Buat tabel `sales_returns`.
  - Implementasikan tabel `sales_returns` (id, uuid, transaction_guid, reason, refund_method, return_date, total_amount, audit standar).
  - Tambahkan Foreign Key ke `transactions(guid)`.
  - Aktifkan RLS pada `sales_returns`.
  - _Requirements: REQ-4_
- [x] 2.2 Buat tabel `sales_return_items`.
  - Implementasikan tabel `sales_return_items` (id, sales_return_id, product_guid, product_name, qty, price).
  - Tambahkan Foreign Key ke `sales_returns(id)` dan `products(uuid)`.
  - Aktifkan RLS pada `sales_return_items`.
  - _Requirements: REQ-5_

### Tahap 3: Pembuatan Ledger Triggers Penjualan
- [x] 3.1 Buat trigger `trg_sync_sales_stock_movement` pada `transaction_details`.
  - Buat fungsi database `public.sync_sales_stock_movement_func()`. Fungsi ini otomatis meng-insert record pengurangan stok (`movement_type = 'out'`, `qty` bernilai negatif) ke tabel `stock_movements` untuk setiap penjualan item di POS.
  - Ambil `warehouse_id` dari tabel `stocks` terkait.
  - Pasang trigger AFTER INSERT pada `transaction_details`.
  - _Requirements: REQ-2_
- [x] 3.2 Buat trigger `trg_sync_void_transaction_stock` pada `transactions`.
  - Buat fungsi database `public.sync_void_transaction_stock_func()`. Fungsi ini akan mendeteksi ketika `flag` transaksi berubah dari `'done'` menjadi `'void'`.
  - Jika void terjadi, trigger ini otomatis meng-insert record pemulihan stok (`movement_type = 'in'`, `qty` bernilai positif) ke tabel `stock_movements` untuk semua item detail dari transaksi void tersebut secara logis.
  - Pasang trigger AFTER UPDATE OF `flag` pada tabel `transactions`.
  - _Requirements: REQ-1, REQ-2_

### Tahap 4: Konfigurasi Kebijakan RLS (Row Level Security)
- [x] 4.1 Terapkan kebijakan akses RLS modul sales.
  - Buat policy untuk `transactions` dan `sales_returns` berbasis `public.user_has_outlet_access(outlet_id)`.
  - Buat policy untuk `payments` berbasis kueri join/subquery mencocokkan `outlet_id` di `transactions`.
  - Buat policy untuk `transaction_details` dan `sales_return_items` berbasis kueri join/subquery mencocokkan header transaksinya.
  - _Requirements: REQ-6_

## 3. Quality Gates
- [x] Tabel penjualan legacy berhasil ditingkatkan ke presisi desimal dan UUID.
- [x] Tabel `sales_returns` dan `sales_return_items` sukses dibuat di Supabase.
- [x] Simulasi penjualan POS otomatis mengurangi stok di `stocks` dan `products` lewat trigger ledger.
- [x] Simulasi void transaksi POS otomatis mengembalikan stok di `stocks` dan `products` lewat jurnal pembalik ledger.
- [x] RLS membatasi riwayat penjualan POS agar terisolasi per-cabang.
