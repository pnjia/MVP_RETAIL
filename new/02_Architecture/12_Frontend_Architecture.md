---
id: architecture-frontend
title: Frontend Architecture
type: architecture
parent: architecture-bounded-context
tags: frontend, architecture
version: 1.0
---

# Tahap 12 — Frontend Architecture

## Tujuan

Mendefinisikan bagaimana frontend akan dibangun agar:

- scalable
- mudah dipelihara
- reusable
- mudah dikembangkan
- sinkron dengan backend

Tahap ini **belum membahas desain UI**.

---

# Arsitektur Tingkat Tinggi

```text
                 User

                   │

            Web / Mobile

                   │

             Routing Layer

                   │

          Feature / Module Layer

                   │

         Shared Component Layer

                   │

             API Service Layer

                   │

               Backend API
```

---

# Prinsip Frontend

Saya menyarankan beberapa prinsip.

## 1. Feature First

Jangan

```text
components/

pages/

hooks/

utils/
```

karena lama-lama menjadi ribuan file.

Lebih baik

```text
product/

sales/

inventory/

finance/
```

setiap module memiliki seluruh kebutuhan sendiri.

---

# Module Structure

Misalnya Product.

```text
product/

├── pages
├── components
├── hooks
├── services
├── stores
├── types
├── validators
└── utils
```

---

# Global Structure

Saya menyarankan seperti berikut.

```text
src/

├── app
├── modules
├── shared
├── assets
├── providers
├── router
├── styles
└── config
```

---

# Modules

```text
modules/

├── authentication
├── organization
├── dashboard
├── product
├── inventory
├── purchase
├── crm
├── sales
├── finance
├── reporting
└── settings
```

---

# Shared

Shared hanya berisi sesuatu yang benar-benar digunakan banyak module.

```text
shared/

├── components
├── layouts
├── hooks
├── lib
├── services
├── utils
├── constants
├── types
└── icons
```

---

# Component Hierarchy

Saya menyarankan hirarki seperti berikut.

```text
Page

↓

Feature

↓

Section

↓

Component

↓

Primitive UI
```

Contoh

```text
Sales Page

↓

Cart Feature

↓

Cart Table

↓

Cart Item

↓

Button
```

---

# State Management

Jangan semua state dimasukkan ke global.

Pisahkan.

## Global

```text
Authentication

Current User

Current Outlet

Theme

Language
```

---

## Feature

Misalnya

Product

```text
Selected Category

Search Keyword

Current Page
```

Sales

```text
Current Cart

Discount

Customer
```

---

## Local

State yang hanya dipakai satu komponen.

Misalnya

```text
Modal Open

Dropdown

Tooltip
```

---

# Data Fetching

Saya menyarankan pola berikut.

```text
Component

↓

Hook

↓

API Service

↓

Backend
```

Jangan memanggil API langsung dari komponen.

---

# API Layer

Contoh

```text
product.service.ts

sales.service.ts

purchase.service.ts
```

Semua request HTTP berada di sini.

---

# Hook Layer

Misalnya

```text
useProducts()

useCreateProduct()

useInventory()

useSales()
```

Komponen hanya menggunakan hook.

---

# Form Strategy

Pisahkan.

```text
Form

↓

Validation

↓

Submit

↓

Mutation
```

Jangan mencampur semuanya di satu file.

---

# Validation

Pisahkan schema.

Misalnya

```text
product.schema.ts

customer.schema.ts
```

---

# Permission

Frontend tetap memeriksa permission.

Misalnya

```text
PRODUCT_CREATE
```

Maka tombol

```text
Tambah Produk
```

disembunyikan.

Tetapi backend tetap menjadi otoritas utama.

---

# Layout

Saya menyarankan.

```text
Public Layout

Authentication Layout

Dashboard Layout

Print Layout
```

---

# Navigation

Pisahkan.

```text
Sidebar

Topbar

Breadcrumb

Menu
```

semuanya berasal dari konfigurasi.

---

# Theme

Saya menyarankan.

```text
Theme

↓

Design Token

↓

Component

↓

Page
```

Jangan memberi warna langsung pada komponen.

---

# Error Handling

Semua API Error

↓

Global Error Handler

↓

Toast

↓

Form Error

↓

Retry

---

# Loading

Saya menyarankan.

```text
Page Loading

Feature Loading

Table Loading

Button Loading
```

Jangan hanya spinner global.

---

# Folder Product

```text
product/

├── components
│
├── pages
│
├── hooks
│
├── services
│
├── schemas
│
├── stores
│
├── types
│
└── utils
```

---

# Folder Sales

```text
sales/

├── cart
├── checkout
├── payment
├── receipt
├── services
├── hooks
└── pages
```

---

# Dependency Rule

Module tidak boleh saling mengakses secara langsung.

Misalnya

Product

×

langsung import

Inventory

Gunakan

Shared

atau

API

---

# Offline Strategy

Karena POS sering dipakai di lokasi dengan koneksi tidak stabil, saya menyarankan sejak awal menyiapkan:

```text
Local Storage

↓

Pending Queue

↓

Sync Service

↓

Backend
```

Transaksi yang belum tersinkron dapat dikirim ulang saat koneksi kembali tersedia.

---

# Performance Strategy

Saya menyarankan.

- Lazy Loading
- Route Splitting
- Component Memoization
- Virtualized Table
- Image Optimization

---

## Summary

- Mendefinisikan arsitektur frontend dengan pendekatan "Feature First", di mana struktur file dipisahkan berdasarkan fitur/modul, bukan tipe file.
- Menetapkan hierarki komponen (Page -> Feature -> Section -> Component -> Primitive UI) dan strategi manajemen state (Global, Feature, Local).
- Menguraikan pola Data Fetching, Form Strategy, struktur direktori, dan pendekatan performa (Lazy Loading, Offline Strategy).

## Related Domains

- Semua module/domain di UI (Product, Sales, Inventory, Finance, dll)

## Related Processes

- Frontend Development
- State Management
- Data Fetching & Sync
- Offline Strategy Planning

## Related Entities

- UI Components, Hooks, API Services

## Related Database

- Local Storage (sebagai Offline Pending Queue / Sync Service)

## Related API

- Berkomunikasi dengan [Backend Architecture](10_Backend_Architecture.md) melalui API Service Layer.

## Business Rules

- Modul UI tidak boleh saling memanggil (import) secara langsung, melainkan melalui module Shared atau API.
- Pola Data Fetching harus melalui Hook yang memanggil API Service, tidak boleh komponen React memanggil API langsung.
- Pengecekan permission dilakukan di UI untuk menyembunyikan elemen, namun otorisasi akhir tetap ada di Backend.

## References

- [Backend Architecture](10_Backend_Architecture.md)
