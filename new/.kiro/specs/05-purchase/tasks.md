# Tasks Specification: Purchase & Procurement (05-purchase)

## 1. Overview
Rencana kerja ini mengimplementasikan tabel dan kebijakan keamanan untuk Modul Purchase (Procurement) di Supabase MangRitel. Modul ini seluruhnya merupakan tabel baru yang mendukung pencatatan PO, penerimaan barang (GR), dan retur pembelian (PR).

## 2. Task List

### Tahap 1: Pembuatan Tabel Purchase Orders (PO)
- [x] 1.1 Buat tabel `purchase_orders`.
  - Implementasikan tabel `purchase_orders` (id, uuid, po_number, supplier_id, outlet_id, status, order_date, total_amount, notes, audit standar).
  - Tambahkan Foreign Key ke `suppliers(id)` dan `outlets(id)`.
  - Aktifkan RLS pada `purchase_orders`.
  - _Requirements: REQ-1_
- [x] 1.2 Buat tabel `purchase_order_items`.
  - Implementasikan tabel `purchase_order_items` (id, purchase_order_id, product_id, product_name, qty, cost, subtotal).
  - Tambahkan Foreign Key ke `purchase_orders(id)` dan `products(id)`.
  - Aktifkan RLS pada `purchase_order_items`.
  - _Requirements: REQ-2_

### Tahap 2: Pembuatan Tabel Penerimaan Barang (Goods Receipts)
- [x] 2.1 Buat tabel `goods_receipts`.
  - Implementasikan tabel `goods_receipts` (id, uuid, receipt_number, purchase_order_id, warehouse_id, receive_date, status, notes, audit standar).
  - Tambahkan Foreign Key ke `purchase_orders(id)` dan `warehouses(id)`.
  - Aktifkan RLS pada `goods_receipts`.
  - _Requirements: REQ-3_
- [x] 2.2 Buat tabel `goods_receipt_items`.
  - Implementasikan tabel `goods_receipt_items` (id, goods_receipt_id, product_id, qty, batch_number, expiry_date, cost).
  - Tambahkan Foreign Key ke `goods_receipts(id)` dan `products(id)`.
  - Aktifkan RLS pada `goods_receipt_items`.
  - _Requirements: REQ-4_

### Tahap 3: Pembuatan Tabel Retur Pembelian (Purchase Returns)
- [x] 3.1 Buat tabel `purchase_returns`.
  - Implementasikan tabel `purchase_returns` (id, uuid, purchase_order_id, supplier_id, reason, return_date, total_amount, audit standar).
  - Tambahkan Foreign Key ke `purchase_orders(id)` dan `suppliers(id)`.
  - Aktifkan RLS pada `purchase_returns`.
  - _Requirements: REQ-5_
- [x] 3.2 Buat tabel `purchase_return_items`.
  - Implementasikan tabel `purchase_return_items` (id, purchase_return_id, product_id, qty, cost).
  - Tambahkan Foreign Key ke `purchase_returns(id)` dan `products(id)`.
  - Aktifkan RLS pada `purchase_return_items`.
  - _Requirements: REQ-6_

### Tahap 4: Konfigurasi Kebijakan RLS (Row Level Security)
- [x] 4.1 Terapkan kebijakan akses RLS modul purchase.
  - Buat policy untuk `purchase_orders` dan `purchase_returns` berbasis `public.user_has_outlet_access(outlet_id)`.
  - Buat policy untuk `goods_receipts` berbasis `warehouse_id` yang divalidasi ke outlet akses user.
  - Buat policy untuk tabel item-item detail (`purchase_order_items`, `goods_receipt_items`, `purchase_return_items`) berbasis kueri join/subquery mencocokkan dokumen header terkait.
  - _Requirements: REQ-7_

## 3. Quality Gates
- [x] Tabel `purchase_orders`, `goods_receipts`, `purchase_returns` beserta detailnya sukses dibuat di Supabase.
- [x] Relasi foreign key terpasang dengan benar ke master data supplier, outlet, warehouse, dan product.
- [x] RLS policies membatasi pengadaan barang secara terisolasi per-cabang.
