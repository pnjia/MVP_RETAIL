# Requirements Specification: Finance (07-finance)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Finance** di MangRitel. Modul ini bertujuan mengelola pencatatan kas masuk dan kas keluar di setiap cabang/outlet, mencakup pengelompokan jenis kas (`cash_categories`), pencatatan jurnal kas (`cash_transactions`), serta pertanggungjawaban penutupan kasir per-periode/shift (`cash_periods`).

## 2. Requirements

### REQ-1: Cash Categories Management
- **User Story**: 
  As an Outlet Manager, I want to define cash categories (e.g., Office Supplies, Operational Costs, Rent, POS Income), so that we can classify cash movements.
- **Acceptance Criteria**:
  - `WHEN a cash category is created, THE SYSTEM SHALL record outlet_id, name, and type (income or expense).`
  - `THE SYSTEM SHALL enforce type to check against ('income', 'expense').`

### REQ-2: Cash Transactions Recording
- **User Story**: 
  As a Kasir, I want to manually record cash deposits or withdrawals (e.g. buying local cleaning products), so that the cash drawer balance is correct.
- **Acceptance Criteria**:
  - `WHEN a cash transaction is recorded, THE SYSTEM SHALL save category_id, transaction_date, debit (DECIMAL(15,2)) for income, and kredit (DECIMAL(15,2)) for expense, along with description and note.`
  - `THE SYSTEM SHALL enforce source value checks: (SALE, MANUAL, PURCHASE, RETURN).`

### REQ-3: Automatic POS Sale Cash Sync
- **User Story**: 
  As an Owner, I want cash sales at the POS to automatically record an income entry in my cash transactions, so that cashiers don't have to write manual entries for cash sales.
- **Acceptance Criteria**:
  - `WHEN a payment is inserted with payment_methode = 'CASH' at POS, THE SYSTEM SHALL automatically trigger a cash_transaction entry under a default 'Penjualan POS' category with debit = paid - change_amount.`

### REQ-4: Cash Periods (Shift Closing)
- **User Story**: 
  As a Cashier, I want to close my cashier shift and count the cash drawer money, so that I can submit my opening balance, closing balance, and matched transactions to the manager.
- **Acceptance Criteria**:
  - `WHEN a cash period is opened/closed, THE SYSTEM SHALL record start_date, end_date, opening_balance (DECIMAL(15,2)), closing_balance (DECIMAL(15,2)), and transactions_ids text.`

### REQ-5: RLS and Security Isolation
- **User Story**: 
  As an Owner, I want my financial records and shift closing reports to be isolated, so that cashiers from outlet A cannot view the financial cash logs of outlet B.
- **Acceptance Criteria**:
  - `WHILE querying cash_categories, cash_transactions, and cash_periods, the system SHALL apply RLS policies filtering by the user's outlet access (using user_has_outlet_access).`

## 3. Success Metrics
- **Akurasi Drawer Kasir**: 100% keselarasan saldo uang tunai fisik drawer dengan proyeksi hitung kas di `cash_periods`.
- **Automated Logging**: 100% pembayaran tunai di kasir ter-log otomatis ke arus kas tanpa intervensi manual.

## 4. Constraints
- **Tipe Data**: Nilai keuangan menggunakan `DECIMAL(15,2)`.
- **Database Engine**: Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Sinkronisasi mutasi rekening koran bank otomatis secara real-time via API Open Banking.
- Laporan pajak PPh/PPn korporat otomatis eksternal.
