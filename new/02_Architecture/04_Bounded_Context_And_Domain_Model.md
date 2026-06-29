---
id: architecture-bounded-context
title: Bounded Context And Domain Model
type: architecture
parent: domain-analysis
tags: architecture, ddd
version: 1.0
---

# Tahap 4 — Bounded Context & Domain Model

## Tujuan

Menentukan batas tanggung jawab setiap domain agar:

- tidak saling tumpang tindih
- dependency jelas
- mudah dijadikan module/service
- mudah dipecah menjadi microservice jika suatu saat diperlukan

Tahap ini **belum membahas tabel database**.

---

# Gambaran Arsitektur

```text
                    Business Management System

                     Shared Kernel
                          │
 ┌────────────────────────┼────────────────────────┐
 │                        │                        │
 ▼                        ▼                        ▼
Identity              Organization             Settings
 │                        │
 └───────────────┬────────┘
                 │
     ┌───────────┼────────────┐
     ▼           ▼            ▼
 Product      Inventory      CRM
     │            ▲            ▲
     │            │            │
     ▼            │            │
 Purchase ────────┘            │
     │                         │
     ▼                         │
 Sales POS ────────────────────┘
     │
     ▼
 Finance
     │
     ▼
 Reporting
     │
     ▼
 Online Store
```

---

# Bounded Context 1 — Identity

## Responsibility

Hanya mengelola identitas.

## Aggregate Root

```text
User
```

Entity

```text
User

Role

Permission

Session

OTP

RefreshToken
```

Value Object

```text
Email

Password

Phone
```

Tidak mengetahui:

- Product
- Sales
- Inventory

---

# Bounded Context 2 — Organization

Mengelola struktur bisnis.

Aggregate

```text
Business
```

Entity

```text
Business

Outlet

Branch

BusinessSetting
```

Value Object

```text
Business Address

Tax Configuration

Currency
```

---

# Bounded Context 3 — Product

Semua mengenai katalog.

Aggregate Root

```text
Product
```

Entity

```text
Product

Variant

Category

Brand

Unit

Price

Barcode
```

Value Object

```text
SKU

Money

Barcode

Weight
```

Domain Event

```text
ProductCreated

ProductArchived

PriceChanged
```

---

# Bounded Context 4 — Inventory

Ini domain yang paling kompleks.

Aggregate Root

```text
Stock
```

Entity

```text
Stock

StockMovement

Warehouse

Batch

Transfer

Adjustment

StockOpname
```

Value Object

```text
Quantity

Location

Lot Number

Expiry Date
```

Domain Event

```text
StockAdded

StockReduced

StockAdjusted

TransferCompleted
```

---

# Bounded Context 5 — Purchase

Aggregate

```text
PurchaseOrder
```

Entity

```text
PurchaseOrder

PurchaseItem

Receiving

PurchaseReturn
```

Value Object

```text
PO Number

Purchase Status
```

Domain Event

```text
PurchaseApproved

GoodsReceived

PurchaseCancelled
```

---

# Bounded Context 6 — CRM

Saya menyarankan **Contact** sebagai aggregate root.

Daripada

```text
Customer

Supplier

Employee
```

lebih baik

```text
Contact
```

yang memiliki beberapa role.

Entity

```text
Contact

CustomerProfile

SupplierProfile

EmployeeProfile
```

Keuntungan:

Satu perusahaan dapat menjadi:

- Supplier
- Customer

secara bersamaan.

Tidak perlu membuat dua data.

---

# Bounded Context 7 — Sales POS

Aggregate Root

```text
Sale
```

Entity

```text
Sale

SaleItem

Payment

Invoice

Cart
```

Value Object

```text
Discount

Tax

Money

Receipt Number
```

Domain Event

```text
SaleCreated

PaymentCompleted

SaleCancelled
```

---

# Bounded Context 8 — Finance

Aggregate

```text
CashSession
```

Entity

```text
CashSession

CashTransaction

Expense

Income

CashCategory
```

Value Object

```text
Money

TransactionType
```

---

# Bounded Context 9 — Reporting

Ini bukan domain transaksi.

Lebih tepat sebagai Read Model.

Aggregate

```text
Report
```

Entity

```text
SalesReport

PurchaseReport

InventoryReport

ProfitReport
```

---

# Bounded Context 10 — Online Store

Aggregate

```text
Storefront
```

Entity

```text
Storefront

Banner

OnlineOrder

ShareLink
```

---

# Bounded Context 11 — Settings

Aggregate

```text
Setting
```

Entity

```text
Printer

ReceiptTemplate

NotificationSetting

Preference
```

---

# Hubungan Antar Context

```text
Identity
      │
      ▼
Organization
      │
      ▼
 Product
      │
      ▼
 Inventory
      ▲
      │
 Purchase
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

CRM

```text
CRM

Customer ───────► Sales

Supplier ───────► Purchase
```

Online Store

```text
Product

↓

Online Store

↓

Sales
```

---

# Shared Kernel

Beberapa object akan dipakai bersama.

```text
Money

Address

Phone

Email

Barcode

Tax

Discount

AuditInfo
```

Tidak perlu didefinisikan berulang.

---

# Anti Corruption Layer (ACL)

Jika nanti ada integrasi:

```text
Marketplace

Payment Gateway

WhatsApp

Printer

Courier

Accounting
```

semuanya masuk melalui ACL.

```text
Marketplace

↓

ACL

↓

Sales
```

Jangan biarkan domain mengetahui API eksternal.

---

# Context Dependency

| Context      | Depends On                |
| ------------ | ------------------------- |
| Identity     | -                         |
| Organization | Identity                  |
| Product      | Organization              |
| CRM          | Organization              |
| Inventory    | Product                   |
| Purchase     | Product, Inventory, CRM   |
| Sales        | Product, Inventory, CRM   |
| Finance      | Sales                     |
| Reporting    | Semua Context Operasional |
| Online Store | Product, Inventory        |
| Settings     | Organization              |

---

# Aggregate Ownership

| Aggregate Root | Mengontrol                         |
| -------------- | ---------------------------------- |
| User           | Role, Permission                   |
| Business       | Outlet                             |
| Product        | Variant, Price                     |
| Stock          | Stock Movement                     |
| Purchase Order | Purchase Item                      |
| Contact        | Customer Profile, Supplier Profile |
| Sale           | Sale Item, Payment                 |
| Cash Session   | Cash Transaction                   |
| Storefront     | Banner, Online Order               |
| Setting        | Printer, Receipt                   |

---

# Context Map

```text
Identity
      │
      ▼
Organization
      │
 ┌────┼─────┐
 ▼    ▼     ▼
CRM Product Settings
 │      │
 │      ▼
 │ Inventory
 │      ▲
 ▼      │
Purchase│
 │      │
 └──►Sales
        │
        ▼
    Finance
        │
        ▼
    Reporting
```

---

## Summary

- Mendefinisikan batas tanggung jawab setiap domain (Bounded Context) untuk menghindari tumpang tindih dan mempermudah pemisahan modul.
- Menjelaskan 11 Bounded Context utama: Identity, Organization, Product, Inventory, Purchase, CRM, Sales POS, Finance, Reporting, Online Store, dan Settings.
- Menjabarkan Aggregate Root, Entity, dan Value Object untuk masing-masing domain beserta Context Map.

## Related Domains

- Identity
- Organization
- Product
- Inventory
- Purchase
- CRM
- Sales
- Finance
- Reporting
- Online Store
- Settings

## Related Processes

- Domain Analysis
- Bounded Context Mapping
- Aggregate Design

## Related Entities

- `User`, `Role`, `Permission` (Identity)
- `Business`, `Outlet` (Organization)
- `Product`, `Category`, `Variant` (Product)
- `Stock`, `Warehouse`, `StockMovement` (Inventory)
- `PurchaseOrder`, `Receiving` (Purchase)
- `Contact` (CRM)
- `Sale`, `Payment` (Sales POS)
- `CashSession`, `Expense`, `Income` (Finance)
- `Storefront`, `OnlineOrder` (Online Store)

## Related Database

- Menjadi acuan awal untuk [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md)

## Related API

- Menjadi acuan pembagian module pada [Backend Architecture](10_Backend_Architecture.md)

## Business Rules

- Bounded Context tidak boleh saling tumpang tindih secara fungsional.
- Integrasi dengan sistem eksternal (Marketplace, Payment Gateway, dll) wajib menggunakan Anti Corruption Layer (ACL).
- Entitas pada satu Bounded Context hanya dapat dikontrol oleh Aggregate Root-nya masing-masing.

## References

- [Backend Architecture](10_Backend_Architecture.md)
- [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md)
