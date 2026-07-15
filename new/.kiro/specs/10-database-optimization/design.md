# Design Specification: Database Optimization (10-database-optimization)

## 1. Overview
Desain ini mengimplementasikan akselerasi performa query database Supabase MangRitel melalui pembuatan indeks spesifik (seperti Trigram Index untuk fuzzy search nama produk dan Composite Index untuk transaksi/ledger) serta penyediaan view helper ekspor/impor data produk secara massal.

## 2. Component Design & Indexes

### Trigram GIN Search Index (`pg_trgm`)
Untuk mempercepat pencarian parsial (seperti mengetik `"Bim"` untuk mencari minyak goreng `"Bimoli"`), kita mengaktifkan ekstensi `pg_trgm` dan membangun index `GIN` pada kolom `name` dan `sku` tabel `products`. Index ini jauh lebih cepat dibanding index `Btree` bawaan yang hanya mendukung kecocokan persis (*exact match*) atau pencarian awalan (`LIKE 'Bim%'`).

### Composite Indexing (Transaksi & Ledger)
- Indeks komposit `idx_transactions_report` mempercepat filter dashboard dan laporan penjualan berdasarkan kombinasi `outlet_id`, range `date`, dan status `flag = 'done'`.
- Indeks komposit `idx_stock_movements_ledger` mempercepat rendering histori kartu stok per-produk per-gudang secara kronologis.

## 3. Data Models & PostgreSQL DDL

```sql
-- 1. Aktifkan Extension Trigram PostgreSQL
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 2. Index Pencarian Produk (Trigram Fuzzy Search)
CREATE INDEX IF NOT EXISTS idx_products_name_trgm ON public.products USING GIN (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_products_sku_trgm ON public.products USING GIN (sku gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products (barcode) WHERE barcode IS NOT NULL AND barcode <> '';

-- 3. Index Performa Laporan Penjualan (Composite)
CREATE INDEX IF NOT EXISTS idx_transactions_perf ON public.transactions (outlet_id, date, flag) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_transaction_details_perf ON public.transaction_details (transaction_guid, product_guid) WHERE deleted_at IS NULL;

-- 4. Index Performa Ledger Stok (Composite & Chronological)
CREATE INDEX IF NOT EXISTS idx_stock_movements_perf ON public.stock_movements (product_guid, warehouse_id, created_at DESC);


-- 5. View Helper Validasi Impor Produk Massal (CSV)
-- View ini membantu API/Frontend mengevaluasi baris impor sebelum dimasukkan ke database utama
CREATE OR REPLACE VIEW public.view_product_import_helper AS
SELECT 
    p.id AS product_id,
    p.sku,
    p.barcode,
    p.name AS product_name,
    p.price,
    p.cost,
    p.outlet_id,
    o.name AS outlet_name,
    p.category_id,
    c.category_name,
    p.brand_id,
    b.name AS brand_name,
    p.unit_id,
    u.name AS unit_name,
    -- Validasi sederhana
    CASE WHEN p.sku IS NULL OR p.sku = '' THEN 'Error: SKU wajib diisi'
         WHEN p.name IS NULL OR p.name = '' THEN 'Error: Nama produk wajib diisi'
         WHEN p.price < 0 THEN 'Error: Harga tidak boleh negatif'
         WHEN p.cost < 0 THEN 'Error: Cost HPP tidak boleh negatif'
         WHEN p.outlet_id IS NULL THEN 'Error: Outlet ID tidak boleh kosong'
         WHEN p.category_id IS NULL AND p.parent_id IS NULL THEN 'Warning: Kategori kosong'
         ELSE 'Valid'
    END AS import_status
FROM public.products p
LEFT JOIN public.outlets o ON p.outlet_id = o.id
LEFT JOIN public.categories c ON p.category_id = c.id
LEFT JOIN public.brands b ON p.brand_id = b.id
LEFT JOIN public.units u ON p.unit_id = u.id
WHERE p.deleted_at IS NULL;
```

## 4. Security & RLS Considerations
- **Index Security**: Index bekerja di tingkat internal mesin PostgreSQL dan secara transparan mematuhi kueri yang disaring oleh RLS. Tidak ada konfigurasi RLS tambahan pada index.
- **Import Helper View**: Mewarisi RLS tabel `products` secara implisit. Pengguna yang mengimpor/membaca hanya bisa memvalidasi produk dari outlet yang mereka kuasai.
