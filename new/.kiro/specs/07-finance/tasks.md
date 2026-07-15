# Tasks Specification: Finance (07-finance)

## 1. Overview
Rencana kerja ini mendokumentasikan langkah-langkah peningkatan tabel keuangan legacy MangRitel (kategori kas, transaksi kas, dan tutup buku kasir) serta pembuatan sistem trigger otomatis pencatat transaksi kas masuk dari POS kasir secara langsung ke jurnal keuangan Supabase.

## 2. Task List

### Tahap 1: Modifikasi Skema Tabel Keuangan Legacy
- [x] 1.1 Modifikasi dan sesuaikan tabel `cash_categories`.
  - Putuskan foreign key lama yang terikat.
  - Rename kolom store_id -> outlet_id, dan sesuaikan kolom audit menjadi snake_case.
  - Tambahkan kolom `deleted_at` TIMESTAMPTZ, konversi boolean `deleted` ke `deleted_at`.
  - Hubungkan Foreign Key ke `outlets(id)`.
  - Aktifkan RLS pada `cash_categories`.
  - _Requirements: REQ-1_
- [x] 1.2 Modifikasi dan sesuaikan tabel `cash_transactions`.
  - Putuskan constraints lama.
  - Ubah tipe data `debit` dan `kredit` ke DECIMAL(15,2).
  - Rename `store_id` to `outlet_id`.
  - Sesuaikan kolom audit ke snake_case, tambahkan `deleted_at`, konversi boolean `deleted` ke `deleted_at`.
  - Pasang Foreign Key ke `outlets(id)` dan `cash_categories(id)`.
  - Aktifkan RLS pada `cash_transactions`.
  - _Requirements: REQ-2_
- [x] 1.3 Modifikasi dan sesuaikan tabel `cash_periods`.
  - Putuskan constraints lama.
  - Ubah tipe data `opening_balance` dan `closing_balance` ke DECIMAL(15,2).
  - Rename `store_id` to `outlet_id`.
  - Sesuaikan kolom audit ke snake_case, tambahkan `deleted_at`, konversi boolean `deleted` ke `deleted_at`.
  - Pasang Foreign Key ke `outlets(id)` dan `cash_transactions(id)`.
  - Aktifkan RLS pada `cash_periods`.
  - _Requirements: REQ-4_

### Tahap 2: Pembuatan Trigger Jurnal Kas POS Otomatis
- [x] 2.1 Buat trigger `trg_sync_sale_to_cash` pada `payments`.
  - Buat fungsi database `public.sync_sale_to_cash_func()`. Fungsi ini mendeteksi insertion pembayaran tunai (`payment_methode = 'CASH'`).
  - Hitung nominal bersih tunai masuk (`NEW.paid - NEW.change_amount`).
  - Cari kategori kas `'Penjualan POS'` (tipe `'income'`) untuk outlet terkait. Jika belum ada, buat otomatis secara on-the-fly.
  - Masukkan record debit baru ke `cash_transactions` bersumber/source `'SALE'`.
  - Pasang trigger AFTER INSERT pada `payments`.
  - _Requirements: REQ-3_

### Tahap 3: Konfigurasi Kebijakan RLS (Row Level Security)
- [x] 3.1 Terapkan kebijakan akses RLS modul finance.
  - Buat policy untuk `cash_categories`, `cash_transactions`, dan `cash_periods` berbasis `public.user_has_outlet_access(outlet_id)`.
  - _Requirements: REQ-5_

## 3. Quality Gates
- [x] Tabel keuangan legacy ter-upgrade ke presisi desimal and audit snake_case.
- [x] Fungsi trigger `public.sync_sale_to_cash_func()` aktif dan sukses diuji.
- [x] Transaksi tunai POS otomatis melahirkan baris debit baru di `cash_transactions` di bawah kategori `'Penjualan POS'`.
- [x] RLS memproteksi total seluruh data keuangan agar terisolasi per-cabang.
