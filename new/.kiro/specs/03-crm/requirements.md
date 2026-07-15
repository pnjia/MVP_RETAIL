# Requirements Specification: Customer Relationship Management (crm)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul CRM & Supplier** pada MangRitel. Modul ini bertujuan mengelola data pelanggan (di level outlet/cabang) dan data pemasok/supplier (di level bisnis/tenant) secara aman dan terisolasi. Otorisasi ini mendukung program loyalitas pelanggan (loyalty points), batasan piutang pelanggan (credit limit), term pembayaran supplier, serta audit data yang handal.

## 2. Requirements

### REQ-1: Customers Table Schema Adaptation
- **User Story**: 
  As a Kasir, I want to record and view customer profiles at my outlet, so that I can apply their loyalty points and check their credit limit during sale checkouts.
- **Acceptance Criteria**:
  - `WHEN the customer database schema is updated, THE SYSTEM SHALL ensure each customer has a unique UUID and set loyalty_points and credit_limit to DECIMAL(15,2).`
  - `WHERE a customer profile is saved, the system SHALL enforce the Unique constraint (outlet_id, phone).`
  - `IF a customer account is deleted, THEN the system SHALL soft-delete the record using the deleted_at timestamp.`

### REQ-2: Suppliers Table Creation
- **User Story**: 
  As a Purchasing Staff, I want to register and manage suppliers at the business level, so that all outlets under my business can order products from the same suppliers.
- **Acceptance Criteria**:
  - `WHEN a supplier is created, THE SYSTEM SHALL generate a unique UUID and link it to the business_id.`
  - `IF a query requests suppliers, THEN the system SHALL only return suppliers that belong to the user's business_id.`
  - `WHERE a supplier is registered, the system SHALL allow optional inputs for tax_id (NPWP) and payment_terms (e.g. NET30).`

### REQ-3: RLS Isolation for CRM Module
- **User Story**: 
  As an Owner, I want my customers and suppliers data to be protected, so that cashiers from other outlets cannot access our customers or supplier details without authorization.
- **Acceptance Criteria**:
  - `WHILE querying customers, the system SHALL apply Row Level Security (RLS) policies to filter data by the user's outlet access (using user_has_outlet_access).`
  - `WHILE querying suppliers, the system SHALL apply RLS policies to filter data by the user's business_id (using get_auth_business_id).`

## 3. Success Metrics
- **Keamanan Data**: 100% data pelanggan dan supplier terproteksi dengan RLS.
- **Validitas Nomor Telepon**: 0% duplikasi nomor telepon pelanggan dalam outlet yang sama.
- **Integritas Migrasi**: 100% data pelanggan legacy berhasil dikonversi ke skema baru tanpa ada record yang terhapus.

## 4. Constraints
- **Tipe Data**: Nilai poin dan limit piutang wajib menggunakan `DECIMAL(15,2)`.
- **Database**: Harus menggunakan Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Fitur auto-broadcast SMS/WhatsApp ke pelanggan (loyalty notification).
- Manajemen invoice piutang supplier secara terperinci (diurus pada modul Finance tersendiri).
