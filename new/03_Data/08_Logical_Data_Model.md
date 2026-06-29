---
id: data-logical
title: Logical Data Model
type: database
parent: data-conceptual
tags: data, logical
version: 1.0
---

# Tahap 8 — Logical Data Model (ERD)

## Tujuan

Mengubah **Business Entity** menjadi **Logical Entity**.

Mulai tahap ini kita sudah menentukan:

- atribut
- primary key
- foreign key
- relationship
- cardinality
- normalisasi

Tetapi **belum menentukan**:

- BIGINT atau UUID
- VARCHAR berapa
- index
- engine database

Itu nanti di Physical Database Design.

---

# Prinsip Desain

Saya menyarankan beberapa prinsip sejak awal.

## 1. Semua Aggregate menjadi Root Table

Misalnya

```text
Product

↓

products
```

```text
Sale

↓

sales
```

```text
Purchase

↓

purchase_orders
```

---

## 2. Child Entity menjadi Child Table

Misalnya

```text
Sale

↓

Sale Item
```

menjadi

```text
sales

sale_items
```

---

## 3. Value Object jangan menjadi table

Misalnya

```text
Money

Address

Barcode
```

cukup menjadi kolom.

---

# Logical Module

Saya membaginya menjadi beberapa module.

```text
Identity

Organization

Master

CRM

Inventory

Purchase

Sales

Finance

Reporting

Settings
```

---

# Module Identity

## users

```text
User

--------

id

username

password

email

status

created_at
```

---

## roles

```text
Role

------

id

name
```

---

## permissions

```text
Permission

-----------

id

name
```

---

## role_permissions

```text
Role

*

↓

*

Permission
```

---

## user_roles

```text
User

*

↓

*

Role
```

---

# Module Organization

## businesses

```text
Business

--------

id

name

tax

currency
```

---

## outlets

```text
Outlet

-------

id

business_id

name

address
```

Relationship

```text
Business

1

↓

N

Outlet
```

---

# Module Product

## categories

```text
Category

--------

id

outlet_id

name
```

---

## brands

```text
Brand

-----

id

name
```

---

## units

```text
Unit

----

id

name
```

---

## products

```text
Product

--------

id

category_id

brand_id

unit_id

name

sku

barcode

status
```

---

## product_variants

```text
Variant

--------

id

product_id

name

barcode

sku
```

---

## prices

Saya justru menyarankan harga dipisahkan.

```text
prices

--------

id

product_id

variant_id

price

cost

effective_date
```

Keuntungannya:

- histori harga
- promo
- future price

---

# CRM

Saya tidak menyarankan membuat:

```text
customers

suppliers
```

Saya lebih suka

```text
contacts
```

kemudian

```text
customer_profiles

supplier_profiles
```

karena

```text
PT ABC
```

bisa menjadi:

✓ customer

✓ supplier

sekaligus.

---

# Purchase

## purchase_orders

```text
Purchase Order

---------------

id

supplier_id

status

date
```

---

## purchase_order_items

```text
id

purchase_order_id

product_id

qty

cost
```

---

## receivings

```text
id

purchase_order_id

date
```

---

## receiving_items

```text
id

receiving_id

product_id

qty

batch
```

---

# Inventory

Saya menyarankan **Stock Movement sebagai pusat inventory**, bukan tabel `stocks` sebagai sumber utama.

Modelnya:

```text
Warehouse

↓

Stock

↓

Stock Movement
```

## warehouses

```text
id

outlet_id

name
```

---

## stocks

```text
id

warehouse_id

product_id

available_qty
```

---

## stock_movements

```text
id

stock_id

movement_type

qty

reference_type

reference_id
```

Keuntungan:

Semua perubahan stok dapat ditelusuri.

---

# Sales

## sales

```text
id

customer_id

cashier_id

status

invoice_number
```

---

## sale_items

```text
id

sale_id

product_id

qty

price

discount
```

---

## payments

```text
id

sale_id

method

amount
```

---

## sale_returns

```text
id

sale_id

reason
```

---

# Finance

## cash_sessions

```text
id

cashier_id

opened_at

closed_at
```

---

## cash_transactions

```text
id

cash_session_id

category_id

amount

type
```

---

## cash_categories

```text
id

name
```

---

# Reporting

Saya **tidak membuat table report**.

Report selalu berasal dari query.

Kalau nanti dibutuhkan performa tinggi,

baru dibuat:

```text
materialized_report
```

atau

```text
summary tables
```

---

# Settings

```text
settings

printers

receipt_templates

number_sequences
```

---

# Cross Module Relationship

```text
Business

│

└── Outlet

│

├──────────────┐

▼              ▼

Products    Contacts

│              │

▼              ▼

Inventory   Purchase

│              │

└──────┬───────┘

▼

Sales

▼

Finance

▼

Reporting
```

---

# Normalisasi

Saya menyarankan minimal **Third Normal Form (3NF)**.

Contoh:

Jangan

```text
products

category_name
```

Tetapi

```text
products

category_id
```

---

# Soft Delete

Saya menyarankan seluruh master memakai

```text
deleted_at
```

bukan

```text
is_deleted
```

Karena:

- mengetahui kapan data dihapus
- mudah melakukan restore
- lebih informatif untuk audit

---

# Audit Field

Semua tabel sebaiknya memiliki field audit yang konsisten.

```text
created_at

created_by

updated_at

updated_by

deleted_at

deleted_by
```

Jangan hanya sebagian tabel.

---

# Penamaan

Saya menyarankan menggunakan aturan berikut.

| Jenis       | Penamaan                                 |
| ----------- | ---------------------------------------- |
| Table       | plural snake_case                        |
| PK          | id                                       |
| FK          | `<entity>_id`                            |
| Timestamp   | created_at, updated_at                   |
| Soft Delete | deleted_at                               |
| Status      | status                                   |
| Boolean     | is_xxx                                   |
| Enum        | gunakan lookup table jika sering berubah |

---

## Summary

- Mengubah Conceptual Data Model menjadi Logical Data Model (ERD) dengan menentukan tabel, atribut, primary key, foreign key, dan normalisasi.
- Menerapkan prinsip Aggregate sebagai Root Table dan Child Entity sebagai Child Table, tanpa Value Object sebagai tabel terpisah.
- Menetapkan strategi audit (soft delete, kolom audit konsisten) dan penamaan (snake_case, plural).

## Related Domains

- Identity, Organization, Product, CRM, Purchase, Inventory, Sales, Finance, Reporting, Settings

## Related Processes

- Database Design (Logical Phase)
- ERD Creation
- Normalization (Minimal 3NF)

## Related Entities

- Tables: `users`, `roles`, `businesses`, `outlets`, `products`, `prices`, `contacts`, `purchase_orders`, `stocks`, `stock_movements`, `sales`, `cash_sessions`, dll.

## Related Database

- Menjadi landasan untuk [Physical Database Design](09_Physical_Database_Design.md)

## Related API

- TBD

## Business Rules

- Price dipisahkan ke tabel tersendiri (`prices`) untuk histori harga, promo, dan future price.
- Reporting tidak disimpan dalam tabel transaksi khusus, melainkan summary tables atau materialized view jika perlu.
- Master data wajib menggunakan soft delete (`deleted_at`), bukan boolean `is_deleted`.
- Semua tabel sebaiknya memiliki field audit yang konsisten (`created_at`, `created_by`, dll).

## References

- [Conceptual Data Model](07_Conceptual_Data_Model.md)
- [Physical Database Design](09_Physical_Database_Design.md)
