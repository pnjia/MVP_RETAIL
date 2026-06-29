---
id: domain-analysis
title: Business Domain Analysis
type: domain
parent: root
tags: domain, business
version: 1.0
---

# Tahap 2 — Business Domain Analysis

## Tujuan

Mendefinisikan seluruh domain bisnis yang ada di dalam sistem beserta tanggung jawabnya (responsibility), data yang dikelola, dan hubungan antar domain.

**Output tahap ini:**

- Daftar domain
- Tanggung jawab setiap domain
- Data yang dimiliki
- Domain dependency
- Domain Event (high level)
- Domain Boundary

---

# Gambaran Arsitektur Domain

```text
                    Business Management System

 ┌───────────────────────────────────────────────────────────┐
 │                    Identity & Access                      │
 └───────────────────────────────────────────────────────────┘
                           │
                           ▼
 ┌───────────────────────────────────────────────────────────┐
 │                    Organization                           │
 └───────────────────────────────────────────────────────────┘
                           │
      ┌──────────────┬──────────────┬──────────────┐
      ▼              ▼              ▼              ▼
 Product        Inventory       Purchase        CRM
      │              │              │              │
      └──────────────┴──────────────┴──────────────┘
                     │
                     ▼
                 Sales POS
                     │
                     ▼
                 Finance
                     │
                     ▼
                 Reporting
                     │
                     ▼
               Online Store

                    Settings
```

---

# Domain 1 — Identity & Access

## Tujuan

Mengelola identitas pengguna dan keamanan sistem.

## Responsibility

- Login
- Logout
- Register
- Session
- Permission
- Role
- Authentication
- Authorization

## Entity

```text
User
Role
Permission
Session
Refresh Token
OTP
```

## Domain Event

```text
User Registered

User Logged In

Password Changed

Role Assigned

Permission Updated
```

## Digunakan oleh

Semua domain.

---

# Domain 2 — Organization

## Tujuan

Mengelola struktur bisnis.

## Responsibility

- Business
- Outlet
- Cabang
- Pengaturan Outlet
- Mata uang
- Pajak

## Entity

```text
Business

Outlet

Store Setting
```

## Domain Event

```text
Business Created

Outlet Created

Outlet Updated
```

---

# Domain 3 — Product Management

## Tujuan

Mengelola seluruh katalog produk.

## Responsibility

- Produk
- Kategori
- Brand
- Unit
- Barcode
- Harga
- Bundle
- Variasi

## Entity

```text
Product

Category

Brand

Unit

Variant

Bundle

Price
```

## Domain Event

```text
Product Created

Price Updated

Product Archived
```

---

# Domain 4 — Inventory

Ini salah satu domain terbesar.

## Responsibility

- Stock
- Restock
- Adjustment
- Mutation
- Stock Opname
- Batch
- Expired Product

## Entity

```text
Stock

Stock Movement

Warehouse

Batch

Adjustment

Transfer

Stock Opname
```

## Domain Event

```text
Stock Increased

Stock Reduced

Stock Adjusted

Stock Transferred

Stock Opname Finished
```

---

# Domain 5 — Purchase

## Responsibility

- Supplier
- Purchase Order
- Receiving
- Return Pembelian

## Entity

```text
Supplier

Purchase Order

Purchase Item

Receiving

Purchase Return
```

## Domain Event

```text
Purchase Approved

Receiving Completed

Purchase Returned
```

---

# Domain 6 — Sales POS

Domain yang menjadi inti aplikasi.

## Responsibility

- Cart
- Checkout
- Invoice
- Discount
- Tax
- Payment Request

## Entity

```text
Cart

Transaction

Invoice

Transaction Item

Discount

Tax
```

## Domain Event

```text
Transaction Created

Transaction Paid

Invoice Printed

Sale Cancelled
```

---

# Domain 7 — Finance

Bukan akuntansi penuh, tetapi pengelolaan kas operasional.

## Responsibility

- Cash Flow
- Income
- Expense
- Cash Register
- Shift Kasir
- Closing Kas

## Entity

```text
Cash Transaction

Cash Period

Cash Category

Payment

Cash Drawer
```

## Domain Event

```text
Payment Received

Cash Added

Cash Withdrawn

Shift Closed
```

---

# Domain 8 — CRM

Semua pihak yang berinteraksi dengan bisnis.

## Responsibility

- Customer
- Supplier
- Employee
- Salesman

Saya menyarankan menggunakan satu konsep **Contact** sebagai root entity.

```text
Contact

├── Customer

├── Supplier

├── Employee

└── Salesman
```

Keuntungannya adalah menghindari duplikasi data orang/perusahaan yang dapat memiliki beberapa peran.

## Domain Event

```text
Customer Registered

Supplier Added

Customer Updated
```

---

# Domain 9 — Reporting

Domain ini hanya membaca data dari domain lain.

## Responsibility

- Sales Report
- Inventory Report
- Purchase Report
- Profit Report
- Cash Flow Report
- Dashboard

## Entity

Tidak memiliki entity transaksi utama karena berperan sebagai _read model_.

## Domain Event

```text
Report Generated

Dashboard Refreshed
```

---

# Domain 10 — Online Store

## Responsibility

- Online Catalog
- Banner
- Share Product
- Online Order
- Store Profile

## Entity

```text
Store Front

Banner

Online Order

Share Link
```

## Domain Event

```text
Online Order Created

Banner Published
```

---

# Domain 11 — Settings

## Responsibility

- Printer
- Receipt
- Logo
- Backup
- Notification
- Numbering
- Preferences

## Entity

```text
Setting

Receipt Template

Printer

Notification Setting
```

## Domain Event

```text
Setting Updated

Printer Connected
```

---

# Hubungan Antar Domain

```text
Identity
    │
    ▼
Organization
    │
    ├──────────────┐
    ▼              ▼
Product       CRM
    │
    ▼
Inventory
    ▲
    │
Purchase
    │
    ▼
Sales POS
    │
    ▼
Finance
    │
    ▼
Reporting

Product ─────────► Online Store
```

**Penjelasan:**

- **Identity** menyediakan autentikasi dan otorisasi untuk seluruh sistem.
- **Organization** menjadi konteks bagi hampir semua data bisnis (tenant, outlet).
- **Product** menjadi sumber data utama bagi Inventory, Sales, Purchase, dan Online Store.
- **Purchase** menambah stok melalui Inventory.
- **Sales POS** mengurangi stok melalui Inventory dan menghasilkan transaksi keuangan di Finance.
- **Finance** mencatat arus kas berdasarkan transaksi dari Sales maupun transaksi kas lainnya.
- **Reporting** mengonsumsi data dari seluruh domain untuk menghasilkan laporan.
- **CRM** menyediakan data customer dan supplier yang digunakan oleh Sales dan Purchase.

---

# Domain Dependency Matrix

| Domain       | Bergantung pada          |
| ------------ | ------------------------ |
| Identity     | -                        |
| Organization | Identity                 |
| Product      | Organization             |
| CRM          | Organization             |
| Inventory    | Product, Organization    |
| Purchase     | Inventory, Product, CRM  |
| Sales POS    | Product, Inventory, CRM  |
| Finance      | Sales POS, Organization  |
| Reporting    | Semua domain operasional |
| Online Store | Product, Inventory       |
| Settings     | Organization             |

---

# Prioritas Implementasi Domain

Saya menyarankan urutan implementasi seperti berikut:

| Urutan | Domain             | Alasan                                                    |
| ------ | ------------------ | --------------------------------------------------------- |
| 1      | Identity & Access  | Fondasi autentikasi dan otorisasi.                        |
| 2      | Organization       | Menentukan tenant, outlet, dan konfigurasi bisnis.        |
| 3      | Product Management | Data master yang digunakan banyak domain.                 |
| 4      | CRM                | Customer dan supplier dibutuhkan Sales dan Purchase.      |
| 5      | Inventory          | Mengelola stok dan pergerakannya.                         |
| 6      | Purchase           | Menambah stok melalui proses pembelian.                   |
| 7      | Sales POS          | Proses transaksi utama yang memanfaatkan data sebelumnya. |
| 8      | Finance            | Mengelola kas dan pembayaran dari transaksi.              |
| 9      | Reporting          | Menyediakan laporan dari seluruh aktivitas operasional.   |
| 10     | Online Store       | Kanal penjualan tambahan yang memanfaatkan domain inti.   |
| 11     | Settings           | Melengkapi konfigurasi operasional sistem.                |

---

## Summary

- Mendefinisikan 11 domain utama pada sistem (Identity, Organization, Product, Inventory, Purchase, Sales POS, Finance, CRM, Reporting, Online Store, Settings).
- Merinci tanggung jawab (responsibility), entitas (entities), dan domain events dari setiap domain.
- Menjelaskan hubungan (relationship) dan matriks dependensi antar domain untuk menentukan prioritas implementasi.

## Related Domains

- Terkait erat dengan [Bounded Context And Domain Model](../02_Architecture/04_Bounded_Context_And_Domain_Model.md) dalam arsitektur sistem.

## Related Processes

- [Business Process Mapping](./03_Business_Process_Mapping.md): Detail langkah dan alur kerja untuk setiap domain yang diidentifikasi.

## Related Entities

- Penjabaran rinci seluruh entitas per domain didokumentasikan di [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md) dan [Logical Data Model](../03_Data/08_Logical_Data_Model.md).

## Related Database

- Struktur database masing-masing domain ada di [Physical Database Design](../03_Data/09_Physical_Database_Design.md).

## Related API

- Endpoints dari masing-masing domain diatur pada [API Contract](../04_API/11_API_Contract.md).

## Business Rules

- Aturan bisnis yang membatasi operasi setiap domain ada pada [Business Rules And State Machine](./06_Business_Rules_And_State_Machine.md).

## References

- [Product Vision And Scope](../00_Project/01_Product_Vision_And_Scope.md)
