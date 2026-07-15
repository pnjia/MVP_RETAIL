# Requirements Specification: Database Optimization (10-database-optimization)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Database Optimization** di MangRitel. Modul ini bertujuan mempercepat respon query kritis (seperti pencarian produk di POS kasir), meningkatkan efisiensi pembacaan data transaksi penjualan yang besar, mengoptimalkan kartu stok (`stock_movements`), serta menyiapkan view pembantu untuk impor/ekspor data massal (CSV/Excel).

## 2. Requirements

### REQ-1: High-Speed Product Search (Trigram/FTS)
- **User Story**: 
  As a Kasir, I want to search for products instantly by typing part of their name, SKU, or scanning a barcode, so that the checkout process is extremely fast.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL support fuzzy and partial search on products.name and products.sku.`
  - `THE SYSTEM SHALL use optimized PostgreSQL indexes (e.g. pg_trgm trigram or composite indexes) to keep search queries below 50ms for up to 50,000 product rows.`

### REQ-2: Performance Indexing for Sales & Ledger Queries
- **User Story**: 
  As an Auditor, I want stock movements and sales histories to load instantly even after months of operations, so that I don't experience application lag.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL implement composite index optimization on transaction_details(transaction_guid, product_guid) and transactions(outlet_id, date, flag).`
  - `THE SYSTEM SHALL index stock_movements by (product_guid, warehouse_id, created_at) to accelerate inventory history rendering.`

### REQ-3: Bulk Import Staging & Validation Helper Views
- **User Story**: 
  As an Owner, I want to import my existing product lists from CSV easily, with clear column mapping and validation against missing categories or duplicate SKUs.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL expose helper views (e.g., view_product_import_helper) that maps product fields, displaying validations for missing categories, units, or brands.`

## 3. Success Metrics
- **Kecepatan Pencarian**: Waktu eksekusi query pencarian produk parsial/fuzzy di bawah 50ms.
- **Performa Ledger**: Laporan kartu stok per-produk memuat data dalam waktu kurang dari 100ms.

## 4. Constraints
- **Database Engine**: Supabase (PostgreSQL 17+).
- **Extension**: Boleh mengaktifkan ekstensi PostgreSQL resmi seperti `pg_trgm` (trigram search) jika diperlukan.

## 5. Out of Scope
- Optimasi caching memori aplikasi frontend/backend (Redis/Browser Cache).
- Pembatasan file upload CDN size (diatur di level Storage Bucket API).
