---
id: process-mapping
title: Business Process Mapping
type: process
parent: domain-analysis
tags: process, flow
version: 1.0
---

# Tahap 3 — Business Process Mapping

## Tujuan

Mendokumentasikan seluruh proses bisnis end-to-end, termasuk:

- Aktor yang terlibat
- Trigger
- Langkah-langkah proses
- Output
- Dampak ke domain lain

Output tahap ini akan menjadi dasar untuk:

- Functional Specification
- Domain Event
- Database
- API
- UI Flow

---

# Business Process Landscape

Saya menyarankan membagi proses bisnis berdasarkan domain, bukan berdasarkan menu aplikasi.

```text
Business Management System

├── Authentication Process
├── Organization Process
├── Product Management Process
├── Inventory Process
├── Purchase Process
├── Sales Process
├── Finance Process
├── CRM Process
├── Reporting Process
├── Online Store Process
└── Settings Process
```

---

# Process 1 — Authentication

## Tujuan

Pengguna dapat mengakses sistem.

### Flow

```text
Open App

↓

Login

↓

Authentication

↓

Load User

↓

Load Business

↓

Load Outlet

↓

Open Dashboard
```

---

# Process 2 — Organization

## Flow

```text
Create Business

↓

Create Outlet

↓

Configure Tax

↓

Configure Currency

↓

Invite User

↓

Assign Role

↓

Business Ready
```

---

# Process 3 — Product Management

## Flow

```text
Create Category

↓

Create Unit

↓

Create Product

↓

Set Price

↓

Generate Barcode

↓

Publish Product
```

Jika produk memiliki variasi:

```text
Create Product

↓

Create Variant

↓

Set Variant Price

↓

Set Variant Barcode

↓

Save
```

---

# Process 4 — Purchase

Ini adalah awal siklus persediaan.

```text
Supplier

↓

Purchase Order

↓

Approve Purchase

↓

Receive Goods

↓

Quality Check

↓

Stock Added

↓

Purchase Completed
```

### Dampak

- Inventory bertambah
- Harga pokok dapat berubah
- Finance mencatat hutang atau pembayaran
- Reporting diperbarui

---

# Process 5 — Inventory

## Restock

```text
Stock In

↓

Stock Movement

↓

Update Available Stock

↓

Stock History
```

---

## Adjustment

```text
Select Product

↓

Input Actual Quantity

↓

Calculate Difference

↓

Adjustment

↓

Stock Updated
```

---

## Stock Opname

```text
Start Opname

↓

Count Stock

↓

Compare System

↓

Approve Difference

↓

Create Adjustment

↓

Finish
```

---

## Transfer Barang

```text
Select Source Outlet

↓

Select Destination Outlet

↓

Create Transfer

↓

Ship

↓

Receive

↓

Update Stock
```

---

# Process 6 — Sales POS

Ini merupakan proses inti sistem.

```text
Open POS

↓

Scan Barcode

↓

Cart

↓

Apply Discount

↓

Select Customer

↓

Payment

↓

Print Receipt

↓

Reduce Stock

↓

Create Cash Transaction

↓

Update Report
```

### Domain yang terlibat

- Product
- Inventory
- CRM
- Finance
- Reporting

---

# Process 7 — Return Sales

```text
Search Invoice

↓

Select Item

↓

Input Return Qty

↓

Validate

↓

Return Approved

↓

Stock Increased

↓

Refund

↓

Report Updated
```

---

# Process 8 — Finance

## Cash In

```text
Receive Money

↓

Select Category

↓

Save Transaction

↓

Cash Balance Updated
```

---

## Cash Out

```text
Expense

↓

Select Category

↓

Save

↓

Cash Reduced
```

---

## Closing Kas

```text
Open Shift

↓

Sales

↓

Cash In

↓

Cash Out

↓

Count Cash

↓

Compare

↓

Close Shift
```

---

# Process 9 — CRM

## Customer

```text
Create Customer

↓

Edit

↓

Transaction History

↓

Purchase History

↓

Loyalty
```

---

## Supplier

```text
Create Supplier

↓

Purchase History

↓

Outstanding

↓

Performance
```

---

# Process 10 — Reporting

```text
User Select Report

↓

Load Data

↓

Aggregate

↓

Generate Report

↓

Export PDF

↓

Export Excel
```

---

# Process 11 — Online Store

```text
Publish Product

↓

Customer Order

↓

Payment

↓

Confirmation

↓

Stock Reduced

↓

Sales Report
```

---

# End-to-End Business Flow

Jika semua proses digabungkan, siklus operasional bisnis menjadi seperti ini:

```text
Supplier
      │
      ▼
Purchase
      │
      ▼
Receiving
      │
      ▼
Inventory
      │
      ▼
Product Ready
      │
      ▼
Sales POS
      │
      ▼
Payment
      │
      ▼
Finance
      │
      ▼
Reporting
```

---

# Cross Domain Flow

## Penjualan

```text
Sales

↓

Inventory

↓

Finance

↓

Report
```

---

## Pembelian

```text
Purchase

↓

Inventory

↓

Finance

↓

Report
```

---

## Retur

```text
Sales Return

↓

Inventory

↓

Finance

↓

Report
```

---

## Stock Opname

```text
Inventory

↓

Adjustment

↓

Report
```

---

# Business Event Matrix

| Event             | Domain Sumber | Domain Terdampak               |
| ----------------- | ------------- | ------------------------------ |
| Product Created   | Product       | Inventory, Sales, Online Store |
| Purchase Approved | Purchase      | Inventory                      |
| Goods Received    | Purchase      | Inventory, Finance             |
| Stock Adjusted    | Inventory     | Reporting                      |
| Sale Completed    | Sales         | Inventory, Finance, Reporting  |
| Sale Cancelled    | Sales         | Inventory, Finance             |
| Payment Received  | Finance       | Reporting                      |
| Customer Created  | CRM           | Sales                          |
| Supplier Created  | CRM           | Purchase                       |
| Shift Closed      | Finance       | Reporting                      |

---

# Business Rules (Global)

Tahap ini juga mulai mendokumentasikan aturan bisnis lintas domain.

### Penjualan

- Produk yang tidak aktif tidak dapat dijual.
- Produk tanpa harga tidak dapat masuk ke transaksi.
- Stok tidak boleh negatif (kecuali diizinkan melalui konfigurasi).

### Pembelian

- Barang diterima hanya dari Purchase Order yang valid.
- Harga pokok diperbarui sesuai kebijakan (misalnya moving average atau FIFO).

### Inventori

- Semua perubahan stok harus menghasilkan riwayat pergerakan stok (_stock movement_).
- Penyesuaian stok memerlukan alasan.

### Keuangan

- Setiap pembayaran penjualan menghasilkan transaksi kas.
- Penutupan kas harus menghitung selisih kas fisik dan kas sistem.

---

## Summary

- Mendokumentasikan langkah-langkah alur proses bisnis inti secara end-to-end (Authentication, Organization, Product Management, Purchase, Inventory, Sales, CRM, Finance, Reporting).
- Menggambarkan interaksi lintas domain (Cross Domain Flow) seperti proses Penjualan, Pembelian, dan Retur.
- Mengidentifikasi event-event bisnis (Business Event Matrix) yang memicu perubahan data pada domain terkait.

## Related Domains

- [Business Domain Analysis](./02_Business_Domain_Analysis.md): Menjadi dasar pengelompokan setiap alur proses.

## Related Processes

- Seluruh proses yang didefinisikan berhubungan secara struktural untuk membangun End-to-End Business Flow dari hulu (Supplier/Purchase) ke hilir (Sales/Report).
- Dioperasionalkan melalui layar antarmuka di [UI FLOW](../05_UI/14_UI_FLOW.md).

## Related Entities

- Mengubah status entitas utama: `Stock`, `Transaction`, `CashTransaction`, `PurchaseOrder`. Lihat [Logical Data Model](../03_Data/08_Logical_Data_Model.md).

## Related Database

- Data setiap proses dicatat pada tabel di [Physical Database Design](../03_Data/09_Physical_Database_Design.md).

## Related API

- Transisi proses membutuhkan orkestrasi pemanggilan endpoint di [API Contract](../04_API/11_API_Contract.md).

## Business Rules

- [Business Rules And State Machine](./06_Business_Rules_And_State_Machine.md): Memberikan prasyarat (precondition) untuk setiap transisi langkah dalam proses (misalnya aturan stok tidak boleh negatif).

## References

- [Functional Specification](./05_Functional_Spesification.md)
