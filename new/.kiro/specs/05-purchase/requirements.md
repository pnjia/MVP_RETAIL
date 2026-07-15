# Requirements Specification: Purchase & Procurement (05-purchase)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Purchase (Procurement)** di MangRitel. Modul ini mendukung rantai pasok pengadaan barang ritel mulai dari pembuatan pesanan pembelian ke supplier (`purchase_orders`), penerimaan barang masuk ke gudang (`goods_receipts`), hingga retur barang rusak/salah ke pemasok (`purchase_returns`). Pengamanan data diatur secara ketat berdasarkan outlet yang mengelola pesanan tersebut.

## 2. Requirements

### REQ-1: Purchase Orders (PO) Management
- **User Story**: 
  As a Purchasing Manager, I want to create and manage purchase orders to suppliers, so that I can buy new inventory for my outlet.
- **Acceptance Criteria**:
  - `WHEN a PO is created, THE SYSTEM SHALL generate a unique UUID, set a unique po_number, link it to supplier_id and outlet_id, and default status to 'draft'.`
  - `THE SYSTEM SHALL restrict status transitions to: draft -> approved -> partially_received / received or cancelled.`
  - `WHERE a PO is saved, the system SHALL enforce total_amount as DECIMAL(15,2).`

### REQ-2: PO Items Detail
- **User Story**: 
  As a Purchasing Staff, I want to add products, their quantities, and expected purchase costs to a PO, so that the supplier knows exactly what we are ordering.
- **Acceptance Criteria**:
  - `WHEN an item is added to a PO, THE SYSTEM SHALL save product_id, snapshot of product_name, cost (DECIMAL(15,2)), qty (DECIMAL(18,4)), and calculate subtotal (qty * cost).`

### REQ-3: Goods Receipts (GR) Management
- **User Story**: 
  As a Gudang Staff, I want to receive incoming shipments based on a PO and store them in a specific warehouse, so that our inventory levels are updated correctly.
- **Acceptance Criteria**:
  - `WHEN a shipment arrives, THE SYSTEM SHALL create a goods_receipt linked to a purchase_order_id and warehouse_id, generating a unique receipt_number.`
  - `IF a GR is saved, THEN the receipt_number SHALL be unique across the business.`

### REQ-4: GR Items Detail
- **User Story**: 
  As a Gudang Staff, I want to record the actual quantity of products received, their batch numbers, and expiry dates, so that we can track batches for safety and quality.
- **Acceptance Criteria**:
  - `WHEN receiving items, THE SYSTEM SHALL record the received qty (DECIMAL(18,4)), cost (DECIMAL(15,2)), optional batch_number, and optional expiry_date.`

### REQ-5: Purchase Returns (PR) Management
- **User Story**: 
  As a Gudang Manager, I want to return damaged or incorrect products to the supplier, so that we get a refund or replacement and reduce our stock count.
- **Acceptance Criteria**:
  - `WHEN returning stock to a supplier, THE SYSTEM SHALL create a purchase_return document detailing the supplier_id, purchase_order_id, reason, return_date, and calculated total_amount.`

### REQ-6: PR Items Detail
- **User Story**: 
  As a Gudang Staff, I want to list the specific products and quantities being returned, so that the return shipment matches our records.
- **Acceptance Criteria**:
  - `WHEN items are added to a return, THE SYSTEM SHALL record product_id, return qty (DECIMAL(18,4)), and cost (DECIMAL(15,2)).`

### REQ-7: RLS and Security Isolation
- **User Story**: 
  As an Owner, I want our POs, receipts, and returns to be secure, so that managers of outlet A cannot view or tamper with procurement of outlet B.
- **Acceptance Criteria**:
  - `WHILE querying purchase_orders, goods_receipts, and purchase_returns, the system SHALL enforce Row Level Security (RLS) policies filtering by the user's outlet access (using user_has_outlet_access).`

## 3. Success Metrics
- **Akurasi Data**: 100% konsistensi antara item yang dipesan di PO dengan item yang diterima di GR (selisih dicatat sebagai outstanding/selisih status).
- **Isolasi Keamanan**: 0 kebocoran akses data pengadaan barang antar-outlet.

## 4. Constraints
- **Tipe Data**: Qty desimal wajib menggunakan `DECIMAL(18,4)`. Nilai uang wajib menggunakan `DECIMAL(15,2)`.
- **Database Engine**: Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Integrasi ERP eksternal (SAP, Oracle NetSuite, dll.).
- Sistem penawaran harga otomatis ke multiple supplier (RFQ bidding).
