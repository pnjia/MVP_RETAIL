# Requirements Specification: Product Variants & Price History (11-product-variants)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Product Variants & Price History** di MangRitel. Modul ini melengkapi katalog produk dengan kemampuan mencatat variasi produk terstruktur (mis. ukuran, warna, rasa) dalam tabel `product_variants`, serta menyimpan riwayat perubahan harga produk secara historis di tabel `product_prices`.

Kedua tabel ini ditandai sebagai *opsional* di desain awal namun penting untuk mendukung skenario produk multi-varian (mis. minuman 330ml vs 600ml, baju S/M/L) dan audit transparansi perubahan harga kepada kasir.

## 2. Requirements

### REQ-1: Product Variants
- **User Story**: 
  As a Store Manager, I want to define product variants (e.g. size L, M, S or color Red, Blue), so that the cashier can pick the correct variant at checkout without creating duplicate products.
- **Acceptance Criteria**:
  - `WHEN a variant is created, THE SYSTEM SHALL record product_id, uuid, name, sku, barcode, price, and cost as DECIMAL(15,2).`
  - `THE SYSTEM SHALL enforce unique uuid per variant.`
  - `THE SYSTEM SHALL support soft-delete (deleted_at).`

### REQ-2: Product Price History
- **User Story**: 
  As an Auditor, I want to see a full history of every price change for each product, so that I can trace which price was active at any date.
- **Acceptance Criteria**:
  - `WHEN a product price changes, THE SYSTEM SHALL record a new entry in product_prices with product_id, variant_id (optional), price, cost, effective_date, and end_date.`
  - `THE SYSTEM SHALL allow querying the active price as the most recent entry where end_date IS NULL.`
  - `THE SYSTEM SHALL migrate existing data from product_price_histories (legacy table) to the new product_prices structure.`

### REQ-3: RLS Security
- **User Story**: 
  As an Owner, I want variants and price history records isolated per outlet, so that managers from other outlets cannot manipulate our product pricing data.
- **Acceptance Criteria**:
  - `WHILE querying product_variants and product_prices, THE SYSTEM SHALL apply RLS based on the product's outlet_id.`

## 3. Success Metrics
- **Konsistensi Harga**: 100% perubahan harga produk ter-log otomatis tanpa duplikasi.
- **Keamanan Varian**: Data varian produk terisolasi 100% per-outlet melalui RLS.

## 4. Constraints
- **Database Engine**: Supabase (PostgreSQL 17+).
- **Backwards Compatible**: Tabel `product_price_histories` legacy tetap dipertahankan sambil tabel baru `product_prices` disediakan sebagai pengganti.

## 5. Out of Scope
- UI pemilih varian di kasir (dikerjakan di Frontend).
- Manajemen stok per-varian otomatis (dikerjakan di modul inventory lanjutan).
