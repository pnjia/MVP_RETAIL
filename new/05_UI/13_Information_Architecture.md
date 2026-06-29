---
id: ui-information-architecture
title: Information Architecture
type: ui
parent: architecture-frontend
tags: ui, ia
version: 1.0
---

# Tahap 13 — Information Architecture (IA)

## Tujuan

Mendefinisikan **struktur informasi** aplikasi sebelum membuat tampilan.

IA menjawab pertanyaan:

- Menu apa saja yang ada?
- Apa hubungan antar menu?
- Siapa yang boleh melihat menu tersebut?
- Informasi apa yang ada di setiap halaman?
- Bagaimana navigasinya?

IA bukan desain.

IA adalah **struktur aplikasi**.

---

# High Level Navigation

Saya membagi aplikasi menjadi beberapa area besar.

```text
Application

├── Authentication
├── Dashboard
├── Sales
├── Inventory
├── Purchase
├── CRM
├── Finance
├── Reporting
├── Settings
└── Account
```

Ini adalah level paling atas.

---

# Dashboard Area

Dashboard bukan sekadar halaman.

Dashboard adalah ringkasan seluruh sistem.

```text
Dashboard

├── Today's Sales

├── Today's Profit

├── Stock Alert

├── Pending Purchase

├── Cash Position

├── Top Product

├── Top Customer

└── Quick Action
```

---

# Sales Area

```text
Sales

├── POS

├── Transactions

├── Returns

├── Payment

├── Invoice

└── Customer History
```

---

# Inventory Area

```text
Inventory

├── Product

├── Category

├── Brand

├── Unit

├── Warehouse

├── Stock

├── Adjustment

├── Transfer

├── Stock Opname

└── Movement History
```

---

# Purchase Area

```text
Purchase

├── Supplier

├── Purchase Order

├── Receiving

├── Return

└── Purchase History
```

---

# Finance Area

```text
Finance

├── Cash Session

├── Cash In

├── Cash Out

├── Cash Category

├── Cash Flow

└── Cash History
```

---

# CRM Area

```text
CRM

├── Customers

├── Suppliers

├── Employees

└── Contact History
```

---

# Reporting Area

```text
Reporting

├── Dashboard

├── Sales Report

├── Purchase Report

├── Inventory Report

├── Cash Flow Report

├── Profit Report

└── Export
```

---

# Settings Area

```text
Settings

├── Business

├── Outlet

├── User

├── Role

├── Printer

├── Tax

├── Receipt

├── Notification

├── Backup

└── Preference
```

---

# Information Hierarchy

Saya membagi informasi menjadi tiga level.

## Level 1

Menu Utama

```text
Sales

Inventory

Purchase

Finance
```

---

## Level 2

Submenu

```text
Sales

↓

Transaction

↓

Transaction Detail
```

---

## Level 3

Action

```text
Transaction Detail

↓

Print

Refund

Edit

Delete
```

---

# Navigation Hierarchy

Contoh Product.

```text
Inventory

↓

Products

↓

Product Detail

↓

Edit Product

↓

Variant

↓

Price History
```

---

# Information Flow

Contoh Sales.

```text
Dashboard

↓

POS

↓

Checkout

↓

Payment

↓

Receipt

↓

Transaction Detail
```

---

# Search Strategy

Saya menyarankan seluruh module mempunyai pola yang sama.

```text
Search

↓

Filter

↓

Sort

↓

Result
```

Misalnya

Product

```text
Keyword

Category

Brand

Status
```

Customer

```text
Keyword

Phone

Status
```

Purchase

```text
Supplier

Status

Date
```

---

# CRUD Navigation

Setiap entity memiliki pola yang sama.

```text
List

↓

Detail

↓

Create

↓

Edit

↓

Archive
```

Dengan demikian pengguna tidak perlu belajar ulang pada setiap modul.

---

# Detail Page Structure

Saya menyarankan semua halaman detail memiliki pola yang konsisten.

```text
Header

↓

Summary

↓

Tabs

↓

Activity

↓

History
```

Contoh Product.

```text
Product

↓

General

↓

Variant

↓

Stock

↓

Price

↓

History
```

---

# Cross Navigation

Contoh.

Sale Detail

```text
Sale

↓

Customer

↓

Customer Detail
```

Sale Detail

↓

Product

↓

Product Detail

Purchase

↓

Supplier

↓

Supplier Detail

Semua hubungan penting dapat dinavigasi tanpa harus kembali ke menu utama.

---

# Information Ownership

| Area      | Informasi Utama   |
| --------- | ----------------- |
| Dashboard | KPI dan ringkasan |
| Sales     | Penjualan         |
| Inventory | Persediaan        |
| Purchase  | Pembelian         |
| Finance   | Arus kas          |
| CRM       | Kontak            |
| Reporting | Analitik          |
| Settings  | Konfigurasi       |

Tidak ada duplikasi informasi.

---

# Permission Navigation

Menu mengikuti hak akses.

Misalnya

Kasir

```text
Dashboard

Sales

Customer
```

Owner

```text
Dashboard

Sales

Inventory

Purchase

Finance

Reporting

Settings
```

Manager

```text
Dashboard

Inventory

Purchase

Report
```

Menu dibangun secara dinamis berdasarkan permission, bukan hardcoded.

---

# Notification Entry Point

Semua notifikasi sebaiknya menjadi pintu masuk ke halaman terkait.

Misalnya.

```text
Stock Minimum

↓

Klik

↓

Product Detail
```

```text
Purchase Approved

↓

Receiving Page
```

```text
Cash Session Closed

↓

Cash Report
```

---

# Breadcrumb Strategy

Contoh.

```text
Dashboard

>

Inventory

>

Products

>

Product Detail

>

Price History
```

Semua halaman level 2 ke atas memiliki breadcrumb.

---

# Global Navigation

Saya menyarankan hanya beberapa menu global.

```text
Search

Notification

Help

Profile

Outlet Switcher
```

Semuanya muncul di Top Navigation.

---

## Summary

This document outlines the Information Architecture (IA) for the MVP Retail application, detailing high-level navigation, information hierarchy, screen flows, search strategy, and permission-based visibility.

## Related Domains

- [All Core Domains](../01_Business/02_Business_Domain_Analysis.md) (mapped to navigation areas like Sales, Inventory, Purchase, Finance, CRM)

## Related Processes

- [Business Process Mapping](../01_Business/03_Business_Process_Mapping.md) (guides the logical grouping of screens and cross-navigation flows)

## Related Entities

- [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md) (represents the core resources displayed in CRUD flows)

## Related Database

- N/A (UI layer is decoupled from physical database)

## Related API

- [API Contract](../04_API/11_API_Contract.md) (feeds the data into the UI modules)

## Business Rules

- [Business Rules & State Machines](../01_Business/06_Business_Rules_And_State_Machine.md) (influences permission navigation, notification triggers, and action availability)

## References

- [Frontend Architecture](../02_Architecture/12_Frontend_Architecture.md)
- [UI Flow](./14_UI_FLOW.md)
- [Screen Specification](./15_Screen_Spesification.md)
