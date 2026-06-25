# Dokumentasi Sistem Ritel (POS)

Dokumentasi modular sistem ritel, dipecah per **tahapan rilis** dan per **modul fitur**.
Setiap modul punya prefix angka agar urutan implementasi jelas.

> **Baca dulu:** [`00_Arsitektur_dan_Stack.md`](00_Arsitektur_dan_Stack.md) — keputusan stack (local-first, SQLite + PostgreSQL + PowerSync, Tauri + React + Laravel) dan strategi bertahap.

## Struktur Tahapan

| Folder | Versi | Tujuan |
|--------|-------|--------|
| `Tahap 1`         | MVP 1.0  | Toko bisa beroperasi (jualan + stok + kas + laporan dasar) |
| `Tahap 1.5`       | 1.5      | Operasional gudang & pembelian (supplier, PO, opname) |
| `Tahap 2.0`       | 2.0      | Level bisnis (kredit, multi-outlet, integrasi, backup) |
| `Tahap Enterprise`| 3.0+     | Skala bisnis (CRM, BI, AI forecast, akuntansi, marketplace) |

## Arsitektur Domain

```
Core          → Authentication, User & Role, Outlet
Master Data   → Product, Category, Customer, Supplier, Pricing
Inventory     → Stock, Adjustment, Movement, Opname
Sales         → POS, Orders, Payments, Receipts
Finance       → Cash In/Out, Credit, Debt
Reporting     → Sales, Finance, Inventory Report
System        → Printer, Backup, Cloud Sync, Audit Log, Settings
```

## Cara Baca Tiap Dokumen Modul

Setiap file modul memuat:
1. **Tujuan** – kenapa modul ini ada
2. **Ruang Lingkup** – fitur yang masuk/keluar
3. **Aktor & Hak Akses** – role yang boleh apa
4. **Data Model** – tabel + field + tipe
5. **Alur Kerja** – flow step-by-step
6. **API / Endpoint** – kontrak (bila ada)
7. **Aturan Bisnis** – rule yang wajib ditegakkan
8. **Validasi & Edge Case**
9. **Acceptance Criteria** – definisi "selesai"
10. **Dependensi** – modul lain yang dibutuhkan

## Konvensi Umum

- **ID**: gunakan UUID atau auto-increment konsisten di semua tabel.
- **Audit fields**: setiap tabel punya `created_at`, `updated_at`, `created_by`.
- **Soft delete**: gunakan `deleted_at` (nullable) untuk data master, jangan hard delete.
- **Uang**: simpan sebagai integer (rupiah, tanpa desimal) atau `decimal(15,2)`. Jangan `float`.
- **Waktu**: simpan UTC, tampilkan sesuai timezone outlet.
