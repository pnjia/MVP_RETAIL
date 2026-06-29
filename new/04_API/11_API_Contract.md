---
id: api-contract
title: API Contract
type: api
parent: architecture-backend
tags: api, contract
version: 1.0
---

# Tahap 11 — API Contract

## Tujuan

Mendefinisikan kontrak komunikasi antara client dan backend.

Output tahap ini meliputi:

- Endpoint
- Request
- Response
- Error
- Validation
- Authentication
- Authorization
- Pagination
- Filtering
- Sorting
- Versioning

---

# API Style

Saya menyarankan menggunakan REST API.

Karakteristik:

- JSON
- Stateless
- JWT Authentication
- Versioning
- Idempotent

Contoh:

```http
POST /api/v1/products

GET /api/v1/products

GET /api/v1/products/{id}

PATCH /api/v1/products/{id}

DELETE /api/v1/products/{id}
```

---

# Resource Mapping

## Identity

```text
POST /auth/login

POST /auth/logout

POST /auth/refresh

POST /auth/forgot-password

POST /auth/reset-password

GET /me
```

---

## Organization

```text
GET /businesses

POST /businesses

GET /outlets

POST /outlets

PATCH /outlets/{id}
```

---

## Product

```text
GET /products

POST /products

GET /products/{id}

PATCH /products/{id}

DELETE /products/{id}
```

---

Variasi

```text
GET /products/{id}/variants

POST /products/{id}/variants

PATCH /variants/{id}
```

---

Kategori

```text
GET /categories

POST /categories
```

---

# Purchase

```text
GET /purchase-orders

POST /purchase-orders

GET /purchase-orders/{id}

PATCH /purchase-orders/{id}
```

Action API

```text
POST /purchase-orders/{id}/approve

POST /purchase-orders/{id}/cancel
```

Receiving

```text
POST /purchase-orders/{id}/receivings
```

---

# Inventory

```text
GET /stocks

GET /stock-movements

POST /stock-adjustments

POST /stock-opnames

POST /stock-transfers
```

---

# Sales

```text
POST /sales

GET /sales

GET /sales/{id}
```

Checkout

```text
POST /sales/{id}/checkout
```

Cancel

```text
POST /sales/{id}/cancel
```

Return

```text
POST /sales/{id}/returns
```

---

# Payment

```text
POST /payments

GET /payments
```

---

# Finance

```text
POST /cash-sessions

POST /cash-sessions/{id}/close

GET /cash-transactions

POST /cash-transactions
```

---

# CRM

```text
GET /contacts

POST /contacts

PATCH /contacts/{id}
```

---

# Reporting

```text
GET /reports/sales

GET /reports/purchase

GET /reports/inventory

GET /reports/cashflow

GET /dashboard
```

---

# Settings

```text
GET /settings

PATCH /settings
```

---

# Standard Request

Misalnya Create Product.

```json
{
  "categoryId": "uuid",
  "brandId": "uuid",
  "unitId": "uuid",
  "name": "Indomie Goreng",
  "sku": "SKU-001",
  "barcode": "899999999999",
  "isStock": true
}
```

---

# Standard Response

Success

```json
{
  "success": true,
  "message": "Product created successfully",
  "data": {
    "id": "uuid"
  }
}
```

---

Error

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "name",
      "message": "Name is required"
    }
  ]
}
```

---

# HTTP Status

| Status | Penggunaan          |
| ------ | ------------------- |
| 200    | Success             |
| 201    | Created             |
| 204    | No Content          |
| 400    | Validation Error    |
| 401    | Unauthorized        |
| 403    | Forbidden           |
| 404    | Not Found           |
| 409    | Conflict            |
| 422    | Business Rule Error |
| 500    | Internal Error      |

---

# Pagination

Semua endpoint list harus konsisten.

Request

```http
GET /products?page=1&size=20
```

Response

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 240,
    "totalPages": 12
  }
}
```

---

# Filtering

Contoh:

```http
GET /products

?categoryId=

&status=

&keyword=

&isActive=
```

---

# Sorting

```http
GET /products

?sort=name

&direction=asc
```

---

# Search

```http
GET /products

?keyword=indomie
```

---

# Authentication

Semua endpoint privat.

```text
Bearer Token

↓

JWT

↓

Middleware

↓

Permission

↓

Controller
```

---

# Authorization

Contoh:

| Endpoint         | Permission     |
| ---------------- | -------------- |
| POST /products   | PRODUCT_CREATE |
| PATCH /products  | PRODUCT_UPDATE |
| DELETE /products | PRODUCT_DELETE |
| GET /products    | PRODUCT_VIEW   |

---

# Idempotency

Beberapa endpoint harus aman dipanggil berulang.

Misalnya

```http
POST /payments
```

menggunakan

```http
Idempotency-Key
```

untuk mencegah pembayaran ganda.

---

# API Versioning

Saya menyarankan:

```text
/api/v1
```

Jika nanti berubah besar:

```text
/api/v2
```

---

# Error Code

Selain HTTP Status, gunakan kode aplikasi.

Contoh:

| Code                      | Arti                           |
| ------------------------- | ------------------------------ |
| PRODUCT_NOT_FOUND         | Produk tidak ditemukan         |
| PRODUCT_SKU_EXISTS        | SKU sudah digunakan            |
| STOCK_NOT_ENOUGH          | Stok tidak mencukupi           |
| PURCHASE_ALREADY_APPROVED | Purchase Order sudah disetujui |
| CASH_SESSION_CLOSED       | Sesi kas sudah ditutup         |

Frontend tidak perlu bergantung pada teks pesan.

---

# OpenAPI

Saya menyarankan seluruh API didokumentasikan menggunakan **OpenAPI 3.1**.

Output:

- Swagger UI
- ReDoc
- Client SDK generation
- API testing

---

# Folder Dokumentasi

```text
11_API_Contract/

├── Authentication.yaml
├── Organization.yaml
├── Product.yaml
├── CRM.yaml
├── Purchase.yaml
├── Inventory.yaml
├── Sales.yaml
├── Finance.yaml
├── Reporting.yaml
├── Settings.yaml
├── Common.yaml
└── openapi.yaml
```

---

## Summary

This document defines the API Contracts for the MVP Retail application, covering endpoints, standard requests/responses, HTTP statuses, and pagination/filtering. It acts as the bridge between the frontend application and backend services.

## Related Domains

- [Identity & Organization](../01_Business/02_Business_Domain_Analysis.md)
- [Product & Inventory](../01_Business/02_Business_Domain_Analysis.md)
- [Sales & Purchase](../01_Business/02_Business_Domain_Analysis.md)
- [Finance & CRM](../01_Business/02_Business_Domain_Analysis.md)

## Related Processes

- [Core Business Processes (Sales, Purchase, Inventory)](../01_Business/03_Business_Process_Mapping.md)
- [Authentication & Authorization](../01_Business/03_Business_Process_Mapping.md)

## Related Entities

- [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md) (e.g., Product, Sale, PurchaseOrder, Stock)
- [Logical Data Model](../03_Data/08_Logical_Data_Model.md)

## Related Database

- [Physical Database Design](../03_Data/09_Physical_Database_Design.md)

## Related API

- This document is the primary API specification.

## Business Rules

- [Business Rules & State Machines](../01_Business/06_Business_Rules_And_State_Machine.md) (covers validation, state transitions for POs and Sales, and authorization permissions mapping to endpoints)

## References

- [Backend Architecture](../02_Architecture/10_Backend_Architecture.md)
- [Frontend Architecture](../02_Architecture/12_Frontend_Architecture.md)
