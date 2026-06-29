---
id: ui-flow
title: UI FLOW
type: ui
parent: ui-information-architecture
tags: ui, flow
version: 1.0
---

# Tahap 14 — UI Flow & Navigation

## Tujuan

Mendokumentasikan seluruh alur interaksi pengguna.

Output:

- User Flow
- Navigation Flow
- Decision Flow
- Validation Flow
- Error Flow

---

# UI Flow Landscape

```text id="k7m2s8"
Application

├── Authentication Flow
├── Dashboard Flow
├── Product Flow
├── Inventory Flow
├── Purchase Flow
├── Sales Flow
├── Finance Flow
├── CRM Flow
├── Reporting Flow
└── Settings Flow
```

---

# Authentication Flow

```text id="3vzw6t"
Splash

↓

Login

↓

Authentication

↓

Load User

↓

Load Outlet

↓

Dashboard
```

Jika gagal.

```text id="mt0jwo"
Login

↓

Error

↓

Retry
```

---

# Dashboard Flow

```text id="4xhtcz"
Dashboard

↓

Widget

↓

Quick Action

↓

Module
```

Quick Action

```text id="pv1p0p"
New Sale

New Product

New Purchase

Cash In
```

---

# Product Flow

```text id="0tfpj2"
Product List

↓

Search

↓

Product Detail

↓

Edit

↓

Save
```

Tambah produk.

```text id="kjvk6j"
Product List

↓

Add Product

↓

Input Form

↓

Validation

↓

Save

↓

Product Detail
```

---

# Variant Flow

```text id="f7uvp4"
Product

↓

Variant

↓

Add Variant

↓

Price

↓

Save
```

---

# Inventory Flow

Stock.

```text id="w5wqxu"
Inventory

↓

Stock

↓

Product

↓

Stock Detail
```

---

Adjustment.

```text id="y3i9sj"
Inventory

↓

Adjustment

↓

Input Qty

↓

Reason

↓

Save
```

---

Transfer.

```text id="m9krg8"
Warehouse

↓

Transfer

↓

Destination

↓

Confirm

↓

Completed
```

---

Stock Opname.

```text id="zjlwmq"
Start Opname

↓

Scan Product

↓

Count

↓

Review

↓

Finish
```

---

# Purchase Flow

```text id="s0rj1w"
Purchase List

↓

Create PO

↓

Add Item

↓

Approve

↓

Receiving

↓

Completed
```

Receiving.

```text id="l2kpvd"
Receiving

↓

Scan Product

↓

Qty

↓

Batch

↓

Expiry

↓

Save
```

---

# Sales Flow

POS.

```text id="tbmvti"
Dashboard

↓

POS

↓

Search Product

↓

Cart

↓

Checkout

↓

Payment

↓

Receipt
```

---

Payment.

```text id="87wz2i"
Checkout

↓

Cash

↓

Confirm

↓

Receipt
```

atau

```text id="06mruw"
Checkout

↓

QRIS

↓

Waiting

↓

Paid

↓

Receipt
```

---

Return.

```text id="sax5bg"
Search Invoice

↓

Select Item

↓

Qty

↓

Refund

↓

Completed
```

---

# Finance Flow

Cash Session.

```text id="yz5qtk"
Open Shift

↓

Sales

↓

Cash In

↓

Cash Out

↓

Close Shift
```

Cash Out.

```text id="b0wd6x"
Cash Out

↓

Category

↓

Amount

↓

Save
```

---

# CRM Flow

Customer.

```text id="y94t6f"
Customer List

↓

Customer Detail

↓

Transaction History
```

Tambah customer.

```text id="k1j1cx"
Customer List

↓

Add Customer

↓

Validation

↓

Save
```

---

# Reporting Flow

```text id="8ujb5w"
Select Report

↓

Filter

↓

Generate

↓

Preview

↓

Export
```

---

# Settings Flow

```text id="1c4dki"
Settings

↓

Business

↓

Edit

↓

Save
```

Printer.

```text id="rby4me"
Printer

↓

Search

↓

Connect

↓

Print Test
```

---

# Decision Flow

Contoh Checkout.

```text id="qek9zi"
Checkout

↓

Payment Method?

├── Cash

├── Transfer

├── QRIS

└── E-Wallet
```

Setiap metode pembayaran mempunyai alur sendiri.

---

# Error Flow

Contoh.

```text id="cpuy4o"
Save Product

↓

Validation Error

↓

Highlight Field

↓

Fix

↓

Save Again
```

Network.

```text id="wkvrw9"
Request

↓

Timeout

↓

Retry

↓

Offline Queue
```

---

# Empty State

Misalnya.

```text id="1cgt7m"
Product

↓

No Product

↓

Create Product
```

Customer.

```text id="h5n0ge"
No Customer

↓

Add Customer
```

---

# Loading Flow

```text id="79t1ii"
Open Page

↓

Skeleton

↓

Data Loaded
```

---

# Navigation Rule

Saya menyarankan aturan.

List

↓

Detail

↓

Edit

↓

Save

↓

Back Detail

↓

Back List

Semua module mengikuti pola yang sama.

---

# Modal Strategy

Contoh.

```text id="r1lghx"
Delete

↓

Confirmation

↓

Delete
```

Tidak langsung delete.

---

# Wizard Flow

Contoh Create Purchase.

```text id="1k63bv"
Supplier

↓

Item

↓

Review

↓

Approve
```

---

# Mobile Navigation

```text id="z7q9gi"
Bottom Navigation

Dashboard

POS

Inventory

Report

Profile
```

---

# Tablet Navigation

```text id="w3vxps"
Sidebar

+

Topbar
```

---

# Desktop Navigation

```text id="2slg6l"
Sidebar

↓

Content

↓

Inspector Panel
```

---

# Cross Navigation

Contoh.

Sale Detail.

```text id="ypx2p0"
Customer

↓

Customer Detail
```

Product.

↓

Stock.

↓

Movement.

Purchase.

↓

Receiving.

↓

Batch.

Semua saling terhubung.

---

## Summary

This document details the step-by-step UI flows, including user interactions, decision trees, validation flows, and error handling for all major modules in the MVP Retail application.

## Related Domains

- [All Core Domains](../01_Business/02_Business_Domain_Analysis.md)

## Related Processes

- [Business Process Mapping](../01_Business/03_Business_Process_Mapping.md) (the UI flows directly reflect the business processes defined here)

## Related Entities

- [Logical Data Model](../03_Data/08_Logical_Data_Model.md) (shapes the data entry forms and wizard flows)

## Related Database

- N/A

## Related API

- [API Contract](../04_API/11_API_Contract.md) (endpoints called during flow transitions, e.g., POST /sales during Checkout flow)

## Business Rules

- [Business Rules & State Machines](../01_Business/06_Business_Rules_And_State_Machine.md) (dictates validation rules and state-dependent UI flows)

## References

- [Information Architecture](./13_Information_Architecture.md)
- [Screen Specification](./15_Screen_Spesification.md)
