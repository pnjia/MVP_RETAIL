# Requirements Specification: Product Catalog & Master Data (product-catalog)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Product Catalog & Master Data** di MangRitel. Modul ini memperluas struktur data produk legacy Mangkasir untuk mendukung manajemen kategori, brand (merek), unit (satuan ukur), varian terstruktur, serta riwayat harga (price history) yang terisolasi per-tenant/outlet untuk kebutuhan retail modern.

## 2. Requirements

### REQ-1: Categories Migration and Outlet Isolation
- **User Story**: 
  As an Owner, I want to manage product categories isolated per outlet, so that each outlet can have a custom category structure.
- **Acceptance Criteria**:
  - `WHEN the category table is created/migrated, THE SYSTEM SHALL rename product_cats to categories and ensure each record has a unique UUID.`
  - `WHERE a category is queried, the system SHALL only return records belonging to the user's outlet_id.`

### REQ-2: Brands Master Table
- **User Story**: 
  As a Manager, I want to define product brands at the business (tenant) level, so that all outlets under my business share the same brand catalog.
- **Acceptance Criteria**:
  - `WHEN a brand is created, THE SYSTEM SHALL link it to the business_id and enforce name uniqueness within that business.`
  - `IF a brand is deleted, THEN the system SHALL set its deleted_at timestamp instead of hard-deleting.`

### REQ-3: Units Master Table & Legacy Unit Extraction
- **User Story**: 
  As an Owner, I want to have a standardized units table and automatically convert legacy product text units to these master records, so that data entry is consistent.
- **Acceptance Criteria**:
  - `WHEN the migration runs, THE SYSTEM SHALL extract unique unit string values (e.g. 'pcs', 'kg') from legacy products, insert them into the units table linked to the business_id, and assign the corresponding unit_id back to products.`
  - `WHERE a unit is created, the system SHALL enforce abbreviation uniqueness within that business.`

### REQ-4: Structured Products Schema Adaptation
- **User Story**: 
  As a Kasir, I want product prices and quantities to support precise decimals, so that I can sell fractional quantities (e.g., 0.5 kg of sugar) and compute exact prices.
- **Acceptance Criteria**:
  - `WHEN products schema is updated, THE SYSTEM SHALL set price and cost columns to DECIMAL(15,2) and quantity (qty) column to DECIMAL(18,4).`
  - `IF a product has variants, THEN the system SHALL support variant self-referencing via parent_id mapping to another product.`
  - `WHERE a product is saved, the system SHALL enforce unique SKU constraint (outlet_id, sku).`

### REQ-5: Structured Product Variants
- **User Story**: 
  As a Kasir, I want to select specific variants of a product (e.g., size XL, color red) with their own SKU, barcode, cost, and price during checkout, so that stock is accurately tracked.
- **Acceptance Criteria**:
  - `WHEN a variant is created, THE SYSTEM SHALL generate a unique record in product_variants linked to a parent product_id.`
  - `IF a variant is selected in POS, THEN the system SHALL use the variant's custom price and cost instead of the parent's default values.`

### REQ-6: Price History (product_prices)
- **User Story**: 
  As an Auditor, I want to track price changes over time for products and variants, so that I can analyze profit margins historically.
- **Acceptance Criteria**:
  - `WHEN a product or variant price/cost is updated, THE SYSTEM SHALL insert a new record in the product_prices table with the effective_date and set the end_date of the previous price record.`
  - `WHILE querying reports, the system SHALL match the transaction date with the effective date range in product_prices to get the historical cost/price.`

## 3. Success Metrics
- **Akurasi Nilai Pecahan**: 100% kuantitas pecahan (mis. 1.250 kg) terhitung dengan presisi tanpa pembulatan tidak akurat.
- **Konsistensi Satuan**: 0% data produk baru yang menggunakan input manual string satuan (semua harus terelasi ke master `units`).
- **Auditabilitas Harga**: Setiap perubahan harga jual terdaftar dalam tabel riwayat `product_prices`.

## 4. Constraints
- **Tipe Data**: Uang menggunakan `DECIMAL(15,2)`, Kuantitas menggunakan `DECIMAL(18,4)`.
- **Supabase**: RLS wajib aktif di seluruh tabel baru/migrasi dengan pembatasan `business_id` atau `outlet_id`.

## 5. Out of Scope
- Sinkronisasi harga otomatis ke platform marketplace luar (Tokopedia/Shopee).
- Label printing barcode secara langsung dari server.
