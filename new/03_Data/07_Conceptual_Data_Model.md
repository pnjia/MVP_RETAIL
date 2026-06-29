---
id: data-conceptual
title: Conceptual Data Model
type: entity
parent: architecture-bounded-context
tags: data, conceptual
version: 1.0
---

# Tahap 7 — Conceptual Data Model

## Tujuan

Mengidentifikasi seluruh **Business Entity** yang benar-benar ada di dunia nyata beserta hubungan antar entitas.

Pada tahap ini:

✅ Entity

✅ Relationship

✅ Cardinality

❌ Tidak ada tipe data

❌ Tidak ada PK

❌ Tidak ada FK

❌ Tidak ada normalisasi

---

# Conceptual Architecture

```text
Business

│

├── Organization

├── Identity

├── Product

├── CRM

├── Purchase

├── Inventory

├── Sales

├── Finance

├── Reporting

└── Settings
```

Setiap domain akan menghasilkan sekumpulan entity.

---

# Domain 1 — Identity

Business Entity

```text
User

Role

Permission

Session

Refresh Token
```

Relationship

```text
Role

1

↓

*

User
```

```text
Role

1

↓

*

Permission
```

---

# Domain 2 — Organization

Entity

```text
Business

Outlet

Business Setting
```

Relationship

```text
Business

1

↓

*

Outlet
```

```text
Outlet

1

↓

1

Business Setting
```

---

# Domain 3 — Product

Entity

```text
Product

Category

Brand

Unit

Variant

Price

Tax
```

Relationship

```text
Category

1

↓

*

Product
```

```text
Brand

1

↓

*

Product
```

```text
Unit

1

↓

*

Product
```

```text
Product

1

↓

*

Variant
```

```text
Variant

1

↓

1

Price
```

---

# Domain 4 — CRM

Saya tetap menyarankan menggunakan satu entity **Contact**.

```text
Contact
```

daripada

```text
Customer

Supplier

Employee
```

Relationship

```text
Contact

1

↓

0..1

Customer Profile
```

```text
Contact

1

↓

0..1

Supplier Profile
```

```text
Contact

1

↓

0..1

Employee Profile
```

Dengan model ini satu perusahaan bisa menjadi customer sekaligus supplier.

---

# Domain 5 — Purchase

Entity

```text
Purchase Order

Purchase Item

Receiving

Receiving Item

Purchase Return
```

Relationship

```text
Supplier

1

↓

*

Purchase Order
```

```text
Purchase Order

1

↓

*

Purchase Item
```

```text
Purchase Order

1

↓

*

Receiving
```

```text
Receiving

1

↓

*

Receiving Item
```

---

# Domain 6 — Inventory

Entity

```text
Warehouse

Stock

Stock Movement

Batch

Transfer

Adjustment

Stock Opname
```

Relationship

```text
Warehouse

1

↓

*

Stock
```

```text
Stock

1

↓

*

Stock Movement
```

```text
Stock

1

↓

*

Batch
```

---

# Domain 7 — Sales

Entity

```text
Cart

Sale

Sale Item

Payment

Invoice

Return
```

Relationship

```text
Customer

1

↓

*

Sale
```

```text
Sale

1

↓

*

Sale Item
```

```text
Sale

1

↓

*

Payment
```

```text
Sale

1

↓

1

Invoice
```

---

# Domain 8 — Finance

Entity

```text
Cash Session

Cash Transaction

Expense

Income

Cash Category
```

Relationship

```text
Cash Session

1

↓

*

Cash Transaction
```

```text
Cash Category

1

↓

*

Cash Transaction
```

---

# Domain 9 — Reporting

Reporting sebenarnya bukan domain penyimpan data utama.

Lebih tepat:

```text
Sales Report

Inventory Report

Purchase Report

Finance Report
```

Semuanya merupakan hasil agregasi dari domain operasional.

---

# Domain 10 — Settings

Entity

```text
Printer

Receipt Template

Notification

Preference
```

---

# Cross Domain Relationship

Inilah yang paling penting.

```text
Business

│

├──────────────┐

▼              ▼

Outlet       User

│

├───────┬───────────┐

▼       ▼           ▼

Product Customer Supplier

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

---

# Master Data vs Transaction Data

Saya juga menyarankan sejak awal mengelompokkan entity.

## Master Data

```text
Business

Outlet

User

Role

Category

Brand

Unit

Product

Contact

Warehouse

Cash Category
```

Jarang berubah.

---

## Transaction Data

```text
Purchase

Receiving

Stock Movement

Stock Adjustment

Stock Opname

Sale

Payment

Invoice

Return

Cash Transaction
```

Terus bertambah.

---

# Reference Data

Ada data yang hampir tidak pernah berubah.

```text
Country

Province

City

District

Village

Currency

Tax

Unit Type
```

---

# Entity Classification

| Jenis       | Entity           |
| ----------- | ---------------- |
| Master      | Product          |
| Master      | Category         |
| Master      | Brand            |
| Master      | Contact          |
| Master      | Warehouse        |
| Transaction | Purchase         |
| Transaction | Receiving        |
| Transaction | Sale             |
| Transaction | Payment          |
| Transaction | Stock Movement   |
| Transaction | Cash Transaction |
| Reference   | Province         |
| Reference   | Currency         |
| Reference   | Tax              |

---

# High-Level Cardinality

| Relationship                    | Cardinality |
| ------------------------------- | ----------- |
| Business → Outlet               | 1 : N       |
| Outlet → Product                | 1 : N       |
| Category → Product              | 1 : N       |
| Product → Variant               | 1 : N       |
| Contact → Purchase              | 1 : N       |
| Contact → Sale                  | 1 : N       |
| Purchase → Purchase Item        | 1 : N       |
| Receiving → Receiving Item      | 1 : N       |
| Sale → Sale Item                | 1 : N       |
| Sale → Payment                  | 1 : N       |
| Product → Stock                 | 1 : N       |
| Stock → Stock Movement          | 1 : N       |
| Cash Session → Cash Transaction | 1 : N       |

---

# Entity Ownership

Ini sering terlupakan, padahal penting.

| Aggregate    | Memiliki                     |
| ------------ | ---------------------------- |
| Business     | Outlet                       |
| Outlet       | Product, Warehouse, Customer |
| Product      | Variant, Price               |
| Purchase     | Purchase Item, Receiving     |
| Sale         | Sale Item, Payment           |
| Stock        | Stock Movement               |
| Cash Session | Cash Transaction             |

---

## Summary

- Mengidentifikasi semua Business Entity di dunia nyata beserta hubungannya (relationship) dan kardinalitas, tanpa menyertakan tipe data atau primary/foreign key.
- Mengelompokkan entitas ke dalam kategori Master Data, Transaction Data, dan Reference Data.
- Mendefinisikan kepemilikan entitas (Entity Ownership) oleh Aggregate.

## Related Domains

- Identity, Organization, Product, CRM, Purchase, Inventory, Sales, Finance, Reporting, Settings

## Related Processes

- Database Design (Conceptual Phase)
- Entity Relationship Identification

## Related Entities

- Master: `Business`, `Outlet`, `User`, `Role`, `Product`, `Category`, `Brand`, `Contact`, `Warehouse`
- Transaction: `Purchase`, `Sale`, `Stock Movement`, `Cash Transaction`
- Reference: `Province`, `Currency`, `Tax`

## Related Database

- Menjadi landasan untuk [Logical Data Model](08_Logical_Data_Model.md)

## Related API

- TBD

## Business Rules

- Satu Contact dapat bertindak sebagai Customer Profile sekaligus Supplier Profile.
- Stock Management dilakukan melalui `Stock Movement` dan `Batch`, bukan sekadar mengubah qty di produk.

## References

- [Bounded Context And Domain Model](../02_Architecture/04_Bounded_Context_And_Domain_Model.md)
- [Logical Data Model](08_Logical_Data_Model.md)
