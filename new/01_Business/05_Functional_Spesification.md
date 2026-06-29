---
id: functional-specification
title: Functional Specification
type: domain
parent: domain-analysis
tags: functional, spec
version: 1.0
---

# Tahap 5 — Functional Specification

## Tujuan

Mendokumentasikan seluruh fungsi sistem secara rinci, sehingga developer, QA, UI/UX, dan product owner memiliki pemahaman yang sama mengenai perilaku sistem.

Setiap fitur akan memiliki:

- Tujuan
- Aktor
- Hak akses
- Trigger
- Preconditions
- Alur utama
- Alur alternatif
- Validasi
- Business Rules
- Output
- Dampak ke domain lain

---

# Struktur Dokumen

Daripada membuat satu dokumen yang sangat besar, saya menyarankan memecahnya per domain.

```text
05_Functional_Specification/

├── 01_Authentication.md
├── 02_Organization.md
├── 03_Product.md
├── 04_Inventory.md
├── 05_Purchase.md
├── 06_CRM.md
├── 07_Sales_POS.md
├── 08_Finance.md
├── 09_Reporting.md
├── 10_Online_Store.md
└── 11_Settings.md
```

Ini jauh lebih mudah dipelihara.

---

# Template Functional Specification

Setiap fitur menggunakan template yang sama.

```text
Feature Name

Description

Actor

Permission

Precondition

Trigger

Main Flow

Alternative Flow

Business Rules

Validation Rules

Exception

Post Condition

Related Domain
```

Dengan template ini seluruh dokumentasi menjadi konsisten.

---

# Contoh — Product Management

## Feature

Tambah Produk

---

### Description

Menambahkan produk baru ke dalam katalog.

---

### Actor

- Owner
- Administrator

---

### Permission

```text
PRODUCT_CREATE
```

---

### Preconditions

- User login
- Outlet aktif
- Hak akses valid

---

### Input

- Nama
- SKU
- Barcode
- Kategori
- Harga
- Harga Modal
- Unit
- Pajak
- Status
- Gambar

---

### Main Flow

```text
Klik Tambah Produk

↓

Isi Data

↓

Validasi

↓

Generate SKU (opsional)

↓

Simpan

↓

Produk Aktif
```

---

### Validation

- Nama wajib
- SKU unik per outlet
- Harga ≥ 0
- Unit wajib
- Kategori wajib

---

### Business Rules

- SKU boleh otomatis.
- Barcode boleh kosong.
- Produk dapat nonaktif.
- Produk dapat berupa jasa.

---

### Post Condition

- Produk tersedia.
- Siap digunakan Inventory.
- Siap dijual.

---

### Related Domain

- Inventory
- Sales
- Online Store

---

# Contoh — Sales POS

## Feature

Checkout

---

### Actor

Kasir

---

### Main Flow

```text
Tambah Barang

↓

Hitung Total

↓

Diskon

↓

Pilih Customer

↓

Pilih Pembayaran

↓

Bayar

↓

Cetak Struk

↓

Selesai
```

---

### Validation

- Cart tidak kosong.
- Produk aktif.
- Harga tersedia.
- Stok cukup (jika stok diaktifkan).

---

### Business Rules

- Stok dikurangi setelah pembayaran berhasil.
- Nomor invoice harus unik.
- Transaksi tidak boleh diubah setelah selesai.

---

### Post Condition

- Penjualan tercatat.
- Kas bertambah.
- Laporan diperbarui.

---

# Contoh — Purchase

### Feature

Terima Barang

Flow

```text
Pilih PO

↓

Input Barang Datang

↓

Input Batch

↓

Input Expired

↓

Simpan

↓

Tambah Stok
```

---

### Validation

- Qty diterima > 0.
- Batch unik dalam penerimaan yang sama (jika digunakan).
- Tanggal kedaluwarsa valid.

---

### Business Rules

- Menambah stok.
- Membuat Stock Movement.
- Memperbarui harga pokok sesuai metode yang dipilih.

---

# Contoh — Inventory

### Feature

Stock Opname

Flow

```text
Mulai Opname

↓

Hitung Fisik

↓

Bandingkan

↓

Selisih

↓

Adjustment

↓

Selesai
```

---

### Validation

- Tidak boleh ada dua opname aktif untuk outlet yang sama.
- Produk yang dihitung harus valid.

---

### Business Rules

- Selisih menghasilkan transaksi penyesuaian stok.
- Riwayat penyesuaian tidak boleh dihapus.

---

# Contoh — Finance

Feature

Cash Out

Flow

```text
Input Pengeluaran

↓

Pilih Kategori

↓

Nominal

↓

Simpan

↓

Saldo Berkurang
```

Validation

- Nominal > 0.
- Kategori wajib.

Business Rules

- Tidak boleh mengubah transaksi kas yang sudah ditutup dalam sesi kas.

---

# Contoh — CRM

Feature

Tambah Customer

Validation

- Nama wajib.
- Nomor telepon unik jika diisi.

Business Rules

- Customer dapat melakukan banyak transaksi.
- Riwayat transaksi tidak hilang meskipun customer dinonaktifkan.

---

# Contoh — Reporting

Feature

Laporan Penjualan

Filter

- Outlet
- Kasir
- Tanggal
- Produk
- Kategori
- Customer

Output

- PDF
- Excel
- Print

---

# Feature Matrix

Saya juga menyarankan membuat matriks untuk memastikan cakupan fitur.

| Domain         | Feature          | Priority |
| -------------- | ---------------- | -------- |
| Authentication | Login            | P0       |
| Authentication | Logout           | P0       |
| Authentication | Reset Password   | P1       |
| Organization   | Outlet           | P0       |
| Product        | Product CRUD     | P0       |
| Product        | Variant          | P1       |
| Product        | Bundle           | P2       |
| Inventory      | Stock In         | P0       |
| Inventory      | Stock Out        | P0       |
| Inventory      | Adjustment       | P0       |
| Inventory      | Opname           | P1       |
| Purchase       | Purchase Order   | P1       |
| Purchase       | Receiving        | P0       |
| Sales          | POS              | P0       |
| Sales          | Return           | P1       |
| Finance        | Cash In          | P0       |
| Finance        | Cash Out         | P0       |
| Finance        | Closing Shift    | P1       |
| CRM            | Customer         | P0       |
| CRM            | Supplier         | P0       |
| Reporting      | Sales Report     | P0       |
| Reporting      | Inventory Report | P1       |
| Settings       | Printer          | P0       |

Prioritas:

- **P0** = wajib untuk MVP.
- **P1** = penting, dapat ditambahkan setelah MVP inti.
- **P2** = pengembangan lanjutan.

---

# Functional Dependency

```text
Product
      │
      ▼
Inventory
      │
      ▼
Purchase

Product
      │
      ▼
Sales
      │
      ▼
Finance
      │
      ▼
Reporting
```

---

# Deliverable Tahap 5

Dokumen yang dihasilkan:

```text
05_Functional_Specification/

├── README.md
├── 01_Authentication.md
├── 02_Organization.md
├── 03_Product.md
├── 04_Inventory.md
├── 05_Purchase.md
├── 06_CRM.md
├── 07_Sales_POS.md
├── 08_Finance.md
├── 09_Reporting.md
├── 10_Online_Store.md
├── 11_Settings.md
└── Feature_Matrix.md
```

---

## Summary

- Mendokumentasikan spesifikasi fungsional untuk fitur-fitur dari tiap domain (Product Management, Sales POS, Purchase, Inventory, Finance, CRM, Reporting).
- Setiap fungsionalitas memiliki aktor, trigger, hak akses (permission), alur utama (main flow), aturan validasi (validation), aturan bisnis, serta hasil (post condition).
- Menyusun Feature Matrix beserta prioritas pengembangannya (P0, P1, P2).

## Related Domains

- [Business Domain Analysis](./02_Business_Domain_Analysis.md): Fitur-fitur ini adalah operasionalisasi dari masing-masing domain.

## Related Processes

- [Business Process Mapping](./03_Business_Process_Mapping.md): Detail "Main Flow" dalam dokumen ini mengimplementasikan alur proses bisnis.

## Related Entities

- Fungsionalitas mengatur pembuatan dan modifikasi data pada [Logical Data Model](../03_Data/08_Logical_Data_Model.md).

## Related Database

- Penyimpanan state akibat fungsionalitas dilakukan di [Physical Database Design](../03_Data/09_Physical_Database_Design.md).

## Related API

- [API Contract](../04_API/11_API_Contract.md): Menjabarkan kontrak permintaan (Request) dan tanggapan (Response) sesuai spesifikasi tiap fitur.

## Business Rules

- [Business Rules And State Machine](./06_Business_Rules_And_State_Machine.md): Menerapkan State Machine (misalnya lifecycle Purchase Order dan Transaksi) untuk memastikan validitas transisi fitur.

## References

- [Development Roadmap](../00_Project/17_Development_Roadmap.md)
