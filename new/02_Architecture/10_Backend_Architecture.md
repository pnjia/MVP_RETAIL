---
id: architecture-backend
title: Backend Architecture
type: architecture
parent: architecture-bounded-context
tags: backend, architecture
version: 1.0
---

# Tahap 10 — Backend Architecture

## Tujuan

Tahap ini mendefinisikan bagaimana sistem akan diimplementasikan pada sisi backend.

Tahap ini menjawab pertanyaan:

- Bagaimana struktur project?
- Bagaimana dependency antar module?
- Bagaimana transaction berjalan?
- Bagaimana event bekerja?
- Bagaimana service saling berkomunikasi?
- Bagaimana permission diterapkan?

Tahap ini **belum membahas endpoint API**.

---

# Target Arsitektur

Saya menyarankan menggunakan **Modular Monolith dengan pendekatan Domain-Driven Design (DDD)**.

Kenapa?

Karena:

- lebih sederhana dibanding microservices
- mudah dikembangkan
- tetap bisa dipecah menjadi microservice di masa depan
- cocok untuk MVP sampai skala menengah

---

# High-Level Architecture

```text
                   Client

           Mobile / Web / Desktop

                     │

                     ▼

                 REST API Layer

                     │

                     ▼

              Application Layer

                     │

                     ▼

                Domain Layer

                     │

                     ▼

             Infrastructure Layer

                     │

                     ▼

                 MySQL Database
```

---

# Layer Architecture

## 1. Presentation Layer

Bertugas menerima request.

Contohnya

```text
Controller

Middleware

Authentication

Validation

Authorization
```

Tidak boleh berisi business logic.

---

## 2. Application Layer

Berisi use case.

Misalnya

```text
Create Product

Update Product

Checkout Sale

Approve Purchase

Close Cash Session
```

Application Layer mengorkestrasi proses bisnis.

---

## 3. Domain Layer

Inilah inti sistem.

Berisi

```text
Entity

Aggregate

Domain Service

Value Object

Domain Event

Repository Interface
```

Tidak mengenal database.

Tidak mengenal HTTP.

Tidak mengenal framework.

---

## 4. Infrastructure Layer

Berisi implementasi teknis.

Misalnya

```text
MySQL

Redis

Storage

Email

Printer

Payment Gateway
```

Semuanya berada di sini.

---

# Module Structure

Saya menyarankan struktur berikut.

```text
src/

├── identity
├── organization
├── product
├── inventory
├── purchase
├── crm
├── sales
├── finance
├── reporting
├── settings
└── shared
```

Masing-masing module berdiri sendiri.

---

# Contoh Module Product

```text
product/

├── application
│
├── domain
│
├── infrastructure
│
└── presentation
```

---

## Application

```text
CreateProduct

UpdateProduct

DeleteProduct

SearchProduct
```

---

## Domain

```text
Product

Variant

Price

Category

Repository

Events
```

---

## Infrastructure

```text
MySQL Repository

Storage

Mapper

Persistence
```

---

## Presentation

```text
Controller

DTO

Validator
```

---

# Dependency Rule

Dependency hanya boleh mengarah ke dalam.

```text
Presentation

↓

Application

↓

Domain

↓

Infrastructure
```

Sebaliknya **tidak boleh**.

---

# Communication

Saya menyarankan dua jenis komunikasi.

## Synchronous

Digunakan untuk:

```text
Create Product

Login

Checkout

Search
```

langsung menggunakan service.

---

## Asynchronous

Digunakan untuk:

```text
Report

Notification

Audit

Email

Log

Activity
```

menggunakan event.

---

# Domain Event

Misalnya

```text
Sale Completed
```

akan menghasilkan event.

```text
SaleCompleted
```

Listener

```text
ReduceStock

CreateCashTransaction

UpdateDashboard

SendReceipt

ActivityLog
```

Dengan demikian modul Sales tidak perlu mengetahui Inventory atau Reporting secara langsung.

---

# Transaction Boundary

Contoh

Checkout.

```text
Checkout

↓

Create Sale

↓

Create Payment

↓

Reduce Stock

↓

Commit
```

Semuanya berada dalam satu database transaction.

Jika salah satu gagal

↓

Rollback.

---

# Repository Pattern

Domain hanya mengenal interface.

```text
ProductRepository
```

Implementasinya

```text
MySQLProductRepository
```

Jika suatu saat berpindah database, Domain tidak berubah.

---

# Shared Module

Berisi object yang digunakan semua domain.

```text
Money

Email

Address

Phone

Barcode

Pagination

AuditInfo
```

---

# Security

Authentication

↓

JWT

↓

Middleware

↓

Permission

↓

Controller

↓

Application

↓

Domain

---

# Permission

Misalnya

```text
PRODUCT_CREATE

PRODUCT_UPDATE

PRODUCT_DELETE

PRODUCT_VIEW
```

Application hanya memanggil

```text
AuthorizationService
```

---

# Validation

Saya menyarankan dua level.

## Request Validation

Memastikan request valid.

Misalnya

```text
name required

price numeric

sku required
```

---

## Domain Validation

Memastikan aturan bisnis.

Misalnya

```text
SKU unik

Harga tidak negatif

Produk aktif
```

---

# Caching

Saya menyarankan cache hanya untuk:

```text
Settings

Category

Brand

Permission

Role
```

Jangan cache transaksi.

---

# Logging

Minimal terdapat:

```text
Application Log

Error Log

Audit Log

Activity Log
```

---

# File Storage

Pisahkan.

```text
Database

↓

Metadata
```

```text
Object Storage

↓

Image

PDF

Attachment
```

Database hanya menyimpan path atau URL.

---

# Integration Layer

Seluruh integrasi eksternal ditempatkan di Infrastructure.

```text
Printer

Payment Gateway

WhatsApp

Email

SMS

Marketplace
```

Jangan dipanggil langsung dari Domain.

---

# Folder Structure

Saya menyarankan struktur berikut.

```text
src/

├── shared
│
├── identity
│
├── organization
│
├── product
│
├── inventory
│
├── purchase
│
├── crm
│
├── sales
│
├── finance
│
├── reporting
│
└── settings
```

Contoh module:

```text
product/

├── application
│   ├── commands
│   ├── queries
│   ├── handlers
│   ├── dto
│   └── services
│
├── domain
│   ├── entities
│   ├── events
│   ├── repositories
│   ├── value-objects
│   └── services
│
├── infrastructure
│   ├── persistence
│   ├── mappers
│   └── integrations
│
└── presentation
    ├── controllers
    ├── requests
    └── responses
```

---

# Cross Module Dependency

```text
Identity

↓

Organization

↓

Product

↓

Inventory

↓

Purchase

↓

Sales

↓

Finance

↓

Reporting
```

CRM digunakan oleh Purchase dan Sales.

Settings digunakan seluruh module.

---

# Deliverable Tahap 10

```text
10_Backend_Architecture/

├── 01_Architecture_Overview.md
├── 02_Layer_Architecture.md
├── 03_Module_Architecture.md
├── 04_Dependency_Rules.md
├── 05_Transaction_Boundary.md
├── 06_Domain_Events.md
├── 07_Repository_Pattern.md
├── 08_Security_Architecture.md
├── 09_Logging_Audit.md
├── 10_Integration_Architecture.md
├── 11_Folder_Structure.md
└── Architecture.drawio
```

---

## Summary

- Mendefinisikan arsitektur backend menggunakan Modular Monolith dengan pendekatan Domain-Driven Design (DDD).
- Menggunakan arsitektur 4 layer: Presentation, Application, Domain, dan Infrastructure.
- Menetapkan aturan dependency antar modul (Presentation -> Application -> Domain -> Infrastructure) dan komunikasi antar servis (Synchronous dan Asynchronous menggunakan Domain Event).

## Related Domains

- Seluruh domain bisnis aplikasi (Identity, Organization, Product, Inventory, Purchase, CRM, Sales, Finance, Reporting, Settings)

## Related Processes

- Backend Development
- Transaction Management
- Event Driven Architecture

## Related Entities

- Seluruh Aggregate Root dan Entity yang didefinisikan pada [Bounded Context](04_Bounded_Context_And_Domain_Model.md)

## Related Database

- MySQL Database (Infrastructure Layer)

## Related API

- REST API Layer (Presentation Layer)
- Integrasi Eksternal (Payment Gateway, WhatsApp, dll) di Infrastructure Layer

## Business Rules

- Dependency kode hanya boleh mengarah ke dalam (Presentation -> Application -> Domain -> Infrastructure).
- Domain Layer tidak boleh mengetahui urusan database, HTTP, atau framework (menerapkan Repository Pattern).
- Proses yang mengubah banyak agregat dalam satu use case (seperti Checkout) dilakukan dalam satu Transaction Boundary.
- Komunikasi antar modul (cross-module) sebaiknya melalui API/Service atau secara asynchronous via Domain Events.

## References

- [Bounded Context And Domain Model](04_Bounded_Context_And_Domain_Model.md)
- Domain-Driven Design (DDD)
- Modular Monolith Architecture
