# Tasks Specification: Reporting & Analytics (08-reporting)

## 1. Overview
Rencana kerja ini mengimplementasikan database views pelaporan bisnis pada database Supabase. Semua tugas difokuskan pada deployment views analitis (Dashboard, Penjualan, Stok Inventaris, PO, dan Kas) dan pengujian integrasi keamanan RLS implisit dari tabel dasar.

## 2. Task List

### Tahap 1: Pembuatan Database Views Pelaporan (Dashboard & Sales)
- [x] 1.1 Buat database view `view_dashboard_metrics`.
  - Implementasikan view untuk merangkum omset, laba HPP, PO belanja hari ini, dan kas bersih per-cabang secara real-time.
  - _Requirements: REQ-1_
- [x] 1.2 Buat database view `view_sales_report`.
  - Implementasikan view histori penjualan POS terperinci (termasuk untung bersih per-item dan snapshot nama produk).
  - _Requirements: REQ-2_

### Tahap 2: Pembuatan Database Views Logistik & Keuangan (Inventory, Purchase, Finance)
- [x] 2.1 Buat database view `view_inventory_report`.
  - Implementasikan view laporan nilai aset gudang berdasarkan saldo stok kali HPP dan potensi pendapatan harga jual.
  - _Requirements: REQ-3_
- [x] 2.2 Buat database view `view_purchase_report`.
  - Implementasikan view status PO belanja barang ke supplier beserta perbandingan kuantitas order vs kuantitas diterima di GR.
  - _Requirements: REQ-4_
- [x] 2.3 Buat database view `view_finance_report`.
  - Implementasikan view arus kas masuk dan kas keluar terperinci tergolong berdasarkan pos kategori keuangan.
  - _Requirements: REQ-5_

### Tahap 3: Pengujian Verifikasi & Validasi Keamanan (Quality Gates)
- [x] 3.1 Verifikasi deployment seluruh views di database.
  - Jalankan test query sederhana untuk memastikan seluruh SQL view berhasil dikompilasi tanpa error reference kolom.
- [x] 3.2 Validasi pewarisan RLS secara implisit.
  - Pastikan query views yang dipicu oleh akun non-Owner secara otomatis ter-filter hanya menampilkan data outlet miliknya saja.
  - _Requirements: REQ-6_

## 3. Quality Gates
- [x] Kelima views (`view_dashboard_metrics`, `view_sales_report`, `view_inventory_report`, `view_purchase_report`, `view_finance_report`) sukses ter-deploy di Supabase.
- [x] Kueri views mematuhi RLS tabel dasar dan data terisolasi 100% per-cabang.
