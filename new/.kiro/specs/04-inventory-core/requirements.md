# Requirements Specification: Inventory Core (04-inventory-core)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Inventory Core** di MangRitel. Modul ini bertujuan mengelola stok barang di tingkat gudang (`warehouses`), pencatatan transaksi masuk (`stock_in`) dan keluar (`stock_out`) berbasis batch, serta menyatukan seluruh riwayat pergerakan stok dalam satu ledger terpadu (`stock_movements`) sebagai sumber kebenaran (source of truth) saldo produk untuk mencegah ketidaksinkronan stok di retail.

## 2. Requirements

### REQ-1: Warehouses Management
- **User Story**: 
  As a Gudang Staff, I want to create multiple warehouse storage locations under my outlet, so that I can track where products are stored physically.
- **Acceptance Criteria**:
  - `WHEN a warehouse is created, THE SYSTEM SHALL generate a unique UUID, associate it with the outlet_id, and default is_default to FALSE.`
  - `IF an outlet has no warehouses, THEN the system SHALL automatically set the first created warehouse as is_default = TRUE.`
  - `WHERE a warehouse is modified, the system SHALL ensure only one warehouse per outlet has is_default = TRUE.`

### REQ-2: Batch Stock Level Tracking (stocks)
- **User Story**: 
  As a Gudang Staff, I want the system to track stock levels partitioned by their incoming batch, so that I can sell products using First-In-First-Out (FIFO) or track expiry dates.
- **Acceptance Criteria**:
  - `WHEN stock is added, THE SYSTEM SHALL record the batch level in the stocks table linked to a warehouse_id, product_uuid, and stock_in_detail_id.`
  - `WHERE stocks are stored, the system SHALL enforce qty to use DECIMAL(18,4) to support fractional units.`

### REQ-3: Stock In Headers and Details
- **User Story**: 
  As a Gudang Staff, I want to record incoming stock shipments (from purchases, returns, or opening balances), so that new stocks are officially registered.
- **Acceptance Criteria**:
  - `WHEN a stock in transaction is created, THE SYSTEM SHALL record the header with a type (PURCHASE/RETURN/ADJUSTMENT/OPENING) and link it to the outlet_id.`
  - `WHERE stock in details are recorded, the system SHALL capture batch_number, cost (DECIMAL(15,2)), qty (DECIMAL(18,4)), and optional expiry_date.`

### REQ-4: Stock Out Headers and Details
- **User Story**: 
  As a Gudang Staff, I want to record outgoing stock (damages, adjustments, transfers), so that lost or removed stock is accounted for.
- **Acceptance Criteria**:
  - `WHEN a stock out transaction is created, THE SYSTEM SHALL record the header with a type (SALE/ADJUSTMENT/DAMAGE/TRANSFER) and link it to the outlet_id.`
  - `WHERE stock out details are recorded, the system SHALL link it to the specific stock batch (stock_id) being consumed.`

### REQ-5: Unified Stock Ledger (stock_movements)
- **User Story**: 
  As an Auditor, I want every stock addition, deduction, or transfer to be recorded in a single transaction log with the running balance, so that I can trace any stock discrepancy historically.
- **Acceptance Criteria**:
  - `WHEN a change occurs in stocks, THE SYSTEM SHALL insert a record in the stock_movements ledger detailing movement_type (in/out/adjustment/transfer), reference_type (purchase/sale/etc.), reference_id, qty, and balance_after.`
  - `WHERE stock_movements is queried, the system SHALL index by product_guid, reference_type, and reference_id for high-speed audits.`

### REQ-6: RLS Data Isolation for Inventory
- **User Story**: 
  As an Owner, I want my inventory and stock movement data to be isolated per outlet cabangnya, so that staff in outlet A cannot see or modify warehouse stock of outlet B.
- **Acceptance Criteria**:
  - `WHILE querying warehouses, stocks, stock_in, stock_out, and stock_movements, the system SHALL apply RLS policies to restrict data based on the user's outlet access (using user_has_outlet_access).`

## 3. Success Metrics
- **Akurasi Saldo**: 100% kecocokan antara total qty di `stocks` dengan kalkulasi kumulatif di `stock_movements` per produk.
- **FIFO Batch Tracking**: Kemampuan memotong stok secara otomatis berdasarkan batch masuk terlama (diimplementasikan di modul transaksi kelak).
- **Isolasi Keamanan**: 100% tabel inventory aman dari akses lintas-outlet tanpa otorisasi.

## 4. Constraints
- **Tipe Data**: Qty menggunakan `DECIMAL(18,4)`, Cost/Price menggunakan `DECIMAL(15,2)`.
- **Database Engine**: Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Sinkronisasi otomatis ke mesin penimbang eksternal pintar.
- Rekomendasi restock otomatis berbasis machine learning (Reorder point diatur manual).
