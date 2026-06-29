---
id: data-physical
title: Physical Database Design
type: database
parent: data-logical
tags: database, physical
version: 1.0
---

# Tahap 9 — Physical Database Design

## Tujuan

Mengubah Logical Data Model menjadi database yang siap diimplementasikan.

Tahap ini mulai menentukan:

- DBMS
- tipe data
- index
- foreign key
- unique constraint
- check constraint
- default value
- partition
- audit
- soft delete
- strategi query

Output tahap ini nantinya langsung bisa diterjemahkan menjadi:

- Migration
- Prisma
- Laravel Migration
- Hibernate Entity
- Drizzle ORM
- SQL Script

---

# 1. Database Architecture

Saya menyarankan sejak awal database dipisahkan secara logis berdasarkan domain.

```text id="f1dbaq"
Business Management System

├── identity
├── organization
├── master
├── inventory
├── purchase
├── sales
├── finance
├── reporting
└── settings
```

Untuk MVP semuanya masih boleh berada dalam satu database.

Misalnya

```text id="2kgdys"
business_management
```

tetapi secara module sudah dipisahkan.

---

# 2. Identifier Strategy

Saya menyarankan seluruh tabel mempunyai dua identifier.

```text id="yew0fg"
id

BIGINT
```

untuk internal database

dan

```text id="eq6t3i"
uuid

UUID
```

untuk public identifier.

Contoh

```text id="zktrjf"
products

id

uuid

name

sku
```

Keuntungan:

- API tidak mengekspos id berurutan.
- Mendukung sinkronisasi offline.
- Aman terhadap enumeration attack.
- Mudah integrasi antar sistem.

---

# 3. Audit Fields

Semua tabel harus memiliki struktur audit yang sama.

```text id="o9ftl3"
created_at

created_by

updated_at

updated_by

deleted_at

deleted_by
```

Tidak ada pengecualian.

---

# 4. Soft Delete

Saya tidak menyarankan

```text id="g0syq2"
is_deleted
```

Saya lebih menyukai

```text id="5mdu9m"
deleted_at
```

karena:

- mengetahui kapan data dihapus
- dapat di-restore
- audit lebih lengkap

---

# 5. Naming Convention

## Table

Plural

```text id="fg9j4n"
products

sales

purchase_orders
```

---

## PK

```text id="7ht7kb"
id
```

---

## FK

```text id="2ef2g8"
product_id

category_id

customer_id
```

---

## Timestamp

```text id="6nuwl0"
created_at

updated_at
```

---

## Boolean

```text id="b4nnny"
is_active

is_default

is_stock
```

---

## Enum

Jika enum sering berubah

Jangan

```text id="z96zwr"
status ENUM
```

Lebih baik

```text id="ojj13j"
status_id
```

ke lookup table.

---

# 6. Tipe Data

Saya menyarankan standar berikut.

| Data        | Type          |
| ----------- | ------------- |
| id          | BIGINT        |
| uuid        | UUID          |
| Name        | VARCHAR(150)  |
| Code        | VARCHAR(50)   |
| SKU         | VARCHAR(100)  |
| Barcode     | VARCHAR(100)  |
| Description | TEXT          |
| Quantity    | DECIMAL(18,4) |
| Price       | DECIMAL(18,2) |
| Percentage  | DECIMAL(5,2)  |
| Date        | DATE          |
| DateTime    | TIMESTAMP     |
| Boolean     | BOOLEAN       |

---

# 7. Money

Jangan pernah menggunakan

```text id="6r8mh2"
FLOAT

DOUBLE
```

untuk uang.

Selalu gunakan

```text id="94p2pr"
DECIMAL(18,2)
```

---

# 8. Quantity

Jangan menggunakan INT.

Lebih baik

```text id="vifjlwm"
DECIMAL(18,4)
```

karena:

- kilogram
- liter
- meter
- gram

---

# 9. Foreign Key Strategy

Semua child menggunakan FK.

Contoh

```text id="kgk25h"
sale_items

sale_id

↓

sales.id
```

---

# 10. Unique Constraint

Contoh

Product

```text id="uw1w7y"
UNIQUE

(outlet_id, sku)
```

Customer

```text id="8e6r9l"
UNIQUE

(outlet_id, phone)
```

Role

```text id="zj40zw"
UNIQUE

(name)
```

---

# 11. Check Constraint

Contoh

Price

```text id="ubxwnv"
price >= 0
```

Qty

```text id="qjlwm8"
qty >= 0
```

Discount

```text id="92opim"
0

↓

100
```

---

# 12. Index Strategy

Primary Index

```text id="8e9uev"
PK
```

---

Unique Index

```text id="wz6vll"
sku

barcode

invoice_number
```

---

Composite Index

```text id="7prpr6"
(outlet_id,status)
```

```text id="cktx8j"
(product_id,warehouse_id)
```

```text id="lsu7jl"
(customer_id,date)
```

---

Search Index

```text id="ejf4lt"
product_name

customer_name
```

---

# 13. Inventory Strategy

Ini yang paling penting.

Saya menyarankan

```text id="1qtf9r"
stocks
```

bukan sumber utama.

Yang menjadi sumber utama adalah

```text id="vhplu8"
stock_movements
```

Kemudian

```text id="gllbva"
stocks
```

hanya projection.

---

# 14. Price Strategy

Jangan

```text id="0qix2t"
products

price
```

Lebih baik

```text id="zjlwmr"
prices
```

Keuntungan

- histori
- promo
- scheduled price
- audit

---

# 15. Reporting Strategy

Saya tidak menyarankan

```text id="px9mr5"
SELECT

JOIN

JOIN

JOIN
```

untuk dashboard.

Lebih baik

```text id="nmubvr"
summary tables
```

atau

```text id="0lc3ao"
materialized view
```

---

# 16. Partition Strategy

Untuk tabel besar.

Misalnya

```text id="h9bzd4"
sales

stock_movements

cash_transactions
```

dipartisi berdasarkan

```text id="lclg6l"
bulan
```

atau

```text id="sxlgs0"
tahun
```

Jika volume data memang tinggi.

---

# 17. Archiving Strategy

Data lama

```text id="f0khqk"
> 5 tahun
```

dipindahkan ke

```text id="fmn7b5"
archive
```

---

# 18. Backup Strategy

Saya menyarankan

```text id="a2b5z0"
Daily

Incremental
```

```text id="zjlwmv"
Weekly

Full Backup
```

```text id="l5j1ps"
Monthly

Archive
```

---

# 19. Security Strategy

Jangan simpan

```text id="sbh2na"
password
```

plain text.

Gunakan

```text id="dl7spw"
Argon2

atau

bcrypt
```

Field sensitif seperti API key atau token sebaiknya dienkripsi atau di-hash sesuai kebutuhan.

---

# 20. Database Module

Saya menyarankan struktur migration seperti berikut.

```text id="k27zbw"
database/

├── identity/

├── organization/

├── master/

├── inventory/

├── purchase/

├── sales/

├── finance/

├── reporting/

└── settings/
```

---

# Deliverable Tahap 9

```text id="1uqh4u"
09_Physical_Database_Design/

├── Database Architecture.md
├── Naming Convention.md
├── Identifier Strategy.md
├── Data Type Standard.md
├── Constraint Strategy.md
├── Index Strategy.md
├── Audit Strategy.md
├── Security Strategy.md
├── Backup Strategy.md
├── Performance Strategy.md
└── Migration Structure.md
```

---

## Summary

- Mengubah Logical Data Model menjadi database fisik yang siap diimplementasikan.
- Menetapkan tipe data standar, constraint (Unique, Check), index strategy, dan strategi foreign key.
- Merencanakan identifier ganda (BIGINT untuk internal, UUID untuk public), strategi pemisahan schema per modul, partitioning, dan archiving.

## Related Domains

- Identity, Organization, Product, CRM, Purchase, Inventory, Sales, Finance, Reporting, Settings

## Related Processes

- Database Design (Physical Phase)
- Database Optimization & Indexing
- Database Migration Creation

## Related Entities

- Seluruh tabel fisik dalam database `business_management` (atau schema yang dipisahkan secara logis).

## Related Database

- Relational Database (contoh: PostgreSQL, MySQL) yang mengimplementasikan tabel-tabel ini.

## Related API

- Public API hanya mengekspos `uuid`, tidak pernah mengekspos `id` (BIGINT) internal.

## Business Rules

- Semua tabel harus memiliki dua identifier: `id` (BIGINT) untuk relasi database, dan `uuid` untuk eksposur publik.
- Nilai uang (Money) wajib menggunakan tipe data DECIMAL, tidak boleh FLOAT atau DOUBLE.
- Quantity wajib menggunakan DECIMAL (contoh DECIMAL(18,4)) untuk mendukung satuan non-bulat.
- Password dan field sensitif lainnya wajib di-hash (misal menggunakan Argon2 atau bcrypt).
- `stock_movements` menjadi sumber utama (source of truth) inventori, sedangkan `stocks` hanya sebagai proyeksi (projection).

## References

- [Logical Data Model](08_Logical_Data_Model.md)
