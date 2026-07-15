# Requirements Specification: Reporting & Analytics (08-reporting)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Reporting & Analytics** di MangRitel. Modul ini ditujukan untuk menyajikan data analitis penjualan, pembelian, stok barang, dan pergerakan kas secara ringkas dan cepat bagi Owner dan Manager melalui SQL Database Views dan Stored Functions, dengan tetap menerapkan Row Level Security (RLS) bawaan.

## 2. Requirements

### REQ-1: Real-time Dashboard Metrics View
- **User Story**: 
  As an Owner, I want to see a real-time summary of today's total sales, profits, purchases, and cash flows on my dashboard, so that I can monitor the business performance instantly.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL expose a view or function returning total_sales, total_profit, total_purchase, total_cash_flow per outlet for the current date.`

### REQ-2: Sales Reports View
- **User Story**: 
  As a Store Manager, I want to view detailed sales reports groupable by date, cashier, category, and payment method, so that I can analyze transaction trends.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL define a public.view_sales_report detailing product, category, invoice, cashier_id, payment method, quantity sold, HPP (cost), sales price, and calculated profit.`

### REQ-3: Inventory & Stock Value Reports View
- **User Story**: 
  As a Store Manager, I want to see the total cost value (HPP) and potential sale value of my current stock in each warehouse, so that I know the asset value of my inventory.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL define a public.view_inventory_report detailing product name, category, warehouse, current stock, cost value (stock * cost), and potential sales value (stock * price).`

### REQ-4: Purchase & Procurement Reports View
- **User Story**: 
  As a Purchasing Manager, I want to see a report of all purchase orders and supplier receipt statuses, so that I can audit supplier fulfillment rates.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL define a public.view_purchase_report showing PO details, supplier name, ordered qty, received qty, total PO cost, and status.`

### REQ-5: Finance & Cash Flow Reports View
- **User Story**: 
  As an Owner, I want to see a profit-and-loss cash statement (income vs expenses), so that I can track our net cash flow.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL define a public.view_finance_report grouping cash movements by category, debit (income), kredit (expense), and net cash flow.`

### REQ-6: Security & Implicit RLS Application
- **User Story**: 
  As an Owner, I want to ensure that a manager querying any report view can only see the data belonging to their authorized outlets, avoiding cross-outlet data leaks.
- **Acceptance Criteria**:
  - `WHEN any reporting view is queried, THE SYSTEM SHALL automatically apply Row Level Security (RLS) inherited from the underlying tables (transactions, products, cash_transactions, etc.) based on the user's outlet access.`

## 3. Success Metrics
- **Keamanan Data**: 100% data laporan patuh terhadap pembatasan outlet RLS.
- **Performa Query**: Kecepatan pemuatan query laporan di bawah 500ms untuk dataset transaksi standard (menggunakan index yang tepat).

## 4. Constraints
- **Database Engine**: Supabase (PostgreSQL 17+).
- **No Direct Table Modification**: Modul ini murni hanya membaca data (*read-only*) menggunakan database views.

## 5. Out of Scope
- Render grafik visual (mis. Bar Chart, Pie Chart) di tingkat database. (Ini dikerjakan oleh UI Frontend).
- Ekspor file PDF/Excel secara native dari PostgreSQL.
