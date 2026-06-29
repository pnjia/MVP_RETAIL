---
id: ui-screen-spec
title: Screen Specification
type: ui
parent: ui-flow
tags: ui, screen
version: 1.0
---

# Tahap 15 — Screen Inventory & Screen Specification

## Tujuan

Mendefinisikan **seluruh layar** yang ada di aplikasi.

Bukan hanya nama halamannya.

Tetapi juga:

- fungsi
- route
- actor
- API
- permission
- state
- komponen
- navigasi

---

# Screen Inventory

Saya membagi berdasarkan module.

```text
Application

├── Authentication
├── Dashboard
├── Product
├── Inventory
├── Purchase
├── Sales
├── Finance
├── CRM
├── Reporting
└── Settings
```

---

# Authentication

## Login

```
Route

/login
```

Purpose

Masuk ke sistem.

Actor

- Owner
- Admin
- Kasir
- Manager

API

```
POST /auth/login
```

Component

```
Email

Password

Remember Me

Login Button

Forgot Password
```

Navigation

```
Login

↓

Dashboard
```

---

# Dashboard

## Dashboard Home

Route

```
/
```

Component

```
Today's Sales

Profit

Stock Alert

Cash

Quick Action

Chart

Recent Transaction
```

Permission

```
DASHBOARD_VIEW
```

---

# Product

## Product List

Route

```
/products
```

Component

```
Search

Category Filter

Brand Filter

Table

Pagination

Toolbar

Export

Import
```

Action

```
Create

View

Edit

Archive
```

API

```
GET /products

DELETE /products/{id}
```

---

## Product Detail

```
/products/:id
```

Tabs

```
General

Variant

Price

Stock

Movement

History
```

Action

```
Edit

Archive

Duplicate
```

---

## Product Create

```
/products/new
```

Component

```
General Form

Price Form

Image

Variant

Save
```

API

```
POST /products
```

---

# Inventory

## Stock List

Route

```
/inventory/stocks
```

Widget

```
Warehouse

Available

Reserved

Minimum

Updated At
```

---

## Stock Movement

```
/inventory/movements
```

Table

```
Date

Product

Type

Qty

Reference

User
```

---

## Stock Adjustment

```
/inventory/adjustments/new
```

Component

```
Product

Qty

Reason

Save
```

---

# Purchase

## Purchase List

```
/purchase-orders
```

Action

```
Create

Approve

Cancel

Receiving
```

---

## Purchase Detail

Tabs

```
General

Items

Receiving

History
```

---

## Receiving

```
Receiving Form

Batch

Expiry

Qty
```

---

# Sales

## POS

Route

```
/sales/pos
```

Layout

```
Product Grid

Cart

Summary

Payment
```

---

## Transaction List

```
/sales
```

Action

```
Refund

Print

Detail
```

---

## Sale Detail

Tabs

```
Summary

Items

Payment

Activity
```

---

# Finance

## Cash Session

```
Open

Current Balance

Cash In

Cash Out

Close
```

---

## Cash Flow

```
Income

Expense

Transfer
```

---

# CRM

## Customer List

```
Search

Table

History
```

---

## Customer Detail

```
General

Transaction

Debt

History
```

---

# Reporting

## Sales Report

Filter

```
Date

Outlet

Cashier

Category
```

Output

```
Chart

Table

PDF

Excel
```

---

# Settings

## Business

```
Business Profile

Tax

Currency

Receipt
```

---

## Printer

```
Printer List

Connect

Test Print
```

---

# Screen Template

Saya menyarankan semua screen menggunakan template yang sama.

```text
Screen Name

Purpose

Route

Actor

Permission

API

Component

Toolbar

Action

Validation

Navigation In

Navigation Out

Loading

Empty State

Error State

Responsive Behaviour
```

---

# Navigation Matrix

| From           | To             |
| -------------- | -------------- |
| Dashboard      | POS            |
| Dashboard      | Product        |
| Product        | Product Detail |
| Product Detail | Edit Product   |
| Purchase       | Receiving      |
| Sales          | Payment        |
| Sales          | Receipt        |
| Customer       | Transaction    |
| Inventory      | Adjustment     |

---

# Permission Matrix

| Screen    | Owner | Admin | Manager | Cashier |
| --------- | ----- | ----- | ------- | ------- |
| Dashboard | ✓     | ✓     | ✓       | ✓       |
| Product   | ✓     | ✓     | ✓       | ✗       |
| Inventory | ✓     | ✓     | ✓       | ✗       |
| Purchase  | ✓     | ✓     | ✓       | ✗       |
| POS       | ✓     | ✓     | ✓       | ✓       |
| Finance   | ✓     | ✓     | ✓       | ✗       |
| Reporting | ✓     | ✓     | ✓       | ✗       |
| Settings  | ✓     | ✓     | ✗       | ✗       |

---

# API Matrix

| Screen         | API                  |
| -------------- | -------------------- |
| Login          | POST /auth/login     |
| Product List   | GET /products        |
| Product Detail | GET /products/{id}   |
| Product Create | POST /products       |
| Purchase       | GET /purchase-orders |
| POS            | POST /sales          |
| Dashboard      | GET /dashboard       |

---

# Component Inventory

Contoh.

```
Button

Input

Textarea

Number Input

Currency Input

Date Picker

Barcode Scanner

Table

Chart

Modal

Drawer

Toast

Badge

Tabs

Pagination

Search

Filter
```

Komponen ini akan menjadi dasar Design System.

---

# Responsive Matrix

| Screen    | Mobile | Tablet | Desktop |
| --------- | ------ | ------ | ------- |
| Login     | ✓      | ✓      | ✓       |
| Dashboard | ✓      | ✓      | ✓       |
| POS       | ✓      | ✓      | ✓       |
| Reporting | ✗      | ✓      | ✓       |
| Settings  | ✗      | ✓      | ✓       |

Tidak semua layar harus tersedia di semua perangkat. Misalnya laporan kompleks mungkin hanya tersedia di tablet dan desktop.

---

## Summary

This document provides a comprehensive inventory and specification for every screen in the MVP Retail application, detailing routes, components, APIs, and permissions.

## Related Domains

- [All Core Domains](../01_Business/02_Business_Domain_Analysis.md)

## Related Processes

- [Functional Specification](../01_Business/05_Functional_Spesification.md) (features mapped to specific screens)

## Related Entities

- [Logical Data Model](../03_Data/08_Logical_Data_Model.md)

## Related Database

- N/A

## Related API

- [API Contract](../04_API/11_API_Contract.md) (specifically the API Matrix correlating screens to endpoints)

## Business Rules

- [Business Rules & State Machines](../01_Business/06_Business_Rules_And_State_Machine.md) (specifically the Permission Matrix)

## References

- [UI Flow](./14_UI_FLOW.md)
- [Design System](./16_Design_System.md)
