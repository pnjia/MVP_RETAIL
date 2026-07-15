# Requirements Specification: Sales POS (06-sales-pos)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Sales POS (Point of Sale)** di MangRitel. Modul ini bertanggung jawab mengelola transaksi penjualan barang ke pelanggan, metode pembayaran (cash, transfer, card, QRIS), retur penjualan (`sales_returns`), serta pengurangan stok otomatis berbasis FIFO/batch HPP yang tercatat rapi di ledger inventaris.

## 2. Requirements

### REQ-1: POS Transactions Management
- **User Story**: 
  As a Kasir, I want to checkout a customer's cart, so that their purchase is recorded, an invoice is generated, and stock is reduced.
- **Acceptance Criteria**:
  - `WHEN a sale is checked out, THE SYSTEM SHALL create a transaction header linking to outlet_id, cashier_id, customer_id, and generating a unique invoice number.`
  - `THE SYSTEM SHALL enforce total fields (sub_total, invoice_discount, invoice_ppn) to use DECIMAL(15,2).`
  - `IF a transaction is voided, THEN its status/flag SHALL be set to 'void' and its associated stock reductions must be reversed.`

### REQ-2: Transaction Details & Stock Deductions
- **User Story**: 
  As a Kasir, I want each item sold to record its unit price, discount, cost (HPP), and the stock batch it was taken from, so that we calculate correct profit margins and update batch inventory.
- **Acceptance Criteria**:
  - `WHEN a transaction detail is inserted, THE SYSTEM SHALL link it to product_guid (UUID), stock_in_id (referring to stocks.id), and capture cost (HPP) as DECIMAL(15,2).`
  - `FOR EVERY item sold, the system SHALL automatically generate a negative stock_movement in stock_movements linked to the transaction's reference_id.`

### REQ-3: Payments Recording
- **User Story**: 
  As a Kasir, I want to record the customer's payment method and amount, so that we know how much cash or electronic money was received and calculate correct change.
- **Acceptance Criteria**:
  - `WHEN a payment is recorded, THE SYSTEM SHALL save payment_methode (CASH/TRANSFER/QRIS/CARD), sub_total, paid, change_amount as DECIMAL(15,2).`

### REQ-4: Sales Returns (SR) Management
- **User Story**: 
  As a Store Manager, I want to process a customer's product return, so that we refund their money, return non-damaged products to inventory, and update our sales records.
- **Acceptance Criteria**:
  - `WHEN a sales return is created, THE SYSTEM SHALL record the reference transaction_guid, reason, refund_method, and return_date.`
  - `THE SYSTEM SHALL support partial returns and update total_amount accordingly.`

### REQ-5: SR Items Detail
- **User Story**: 
  As a Kasir, I want to specify which items and quantities are being returned, so that the refund matches the original transaction price.
- **Acceptance Criteria**:
  - `WHEN an item is returned, THE SYSTEM SHALL record product_guid, return qty, and unit price as DECIMAL.`

### REQ-6: RLS and Security Isolation
- **User Story**: 
  As an Owner, I want our sales and revenue data to be isolated per outlet, so that cashiers at outlet A cannot see the sales history or transactions of outlet B.
- **Acceptance Criteria**:
  - `WHILE querying transactions, transaction_details, payments, and sales_returns, the system SHALL apply RLS policies filtering by the user's outlet access (using user_has_outlet_access).`

## 3. Success Metrics
- **Keamanan Keuangan**: 100% data transaksi dilindungi RLS per outlet.
- **Konsistensi HPP**: 100% item transaksi POS terhubung ke HPP batch (`stock_in_id`) secara valid untuk laporan profitabilitas.
- **Stok Otomatis**: 100% item terjual langsung memotong stok di ledger `stock_movements`.

## 4. Constraints
- **Tipe Data**: Qty desimal menggunakan `DECIMAL(18,4)`. Nilai uang wajib menggunakan `DECIMAL(15,2)`.
- **Database Engine**: Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Integrasi mesin EDC kartu kredit fisik secara otomatis.
- Sistem promosi core terkomplikasi (mis. Buy 1 Get 1 Free dinamis diatur terpisah).
