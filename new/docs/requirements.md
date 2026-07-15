# Requirements Specification: Tenant & Organization Foundation (modul-tenant-organization)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk **Fondasi Tenant & Organization** pada MangRitel. Fitur ini merupakan langkah awal migrasi dari database legacy Mangkasir (single-tenant) ke arsitektur multi-tenant SaaS (berdasarkan Eqiozmart v1) menggunakan Supabase. Nilai bisnis utama dari fitur ini adalah menyediakan pemisahan data yang aman antar-tenant (bisnis) dan antar-outlet (cabang toko) menggunakan Row Level Security (RLS) di database.

## 2. Requirements

### REQ-1: Multi-Tenant Business Entity (Root Tenant)
- **User Story**: 
  As a Business Owner, I want to create a Business entity as the root tenant, so that I can group and manage multiple outlets, settings, and users under one billing/legal entity.
- **Acceptance Criteria**:
  - `WHEN a new business registration is submitted, THE SYSTEM SHALL generate a unique business record with a UUID and set is_active to TRUE.`
  - `IF a business status is set to inactive, THEN the system SHALL immediately reject all API requests from users belonging to that business.`
  - `WHERE a business is registered, the system SHALL default the currency to 'IDR' unless specified otherwise.`

### REQ-2: Multi-Outlet Partitioning under Business
- **User Story**: 
  As a Business Owner, I want to create multiple outlets under my business, so that each physical store location can manage its own transactions, cash flow, and stock isolation.
- **Acceptance Criteria**:
  - `WHEN an outlet is created, THE SYSTEM SHALL validate and link it to a valid business_id.`
  - `IF a query requests outlets list, THEN the system SHALL only return outlets that belong to the user's business_id.`
  - `WHERE an outlet is modified, the system SHALL ensure its unique uuid remains immutable.`

### REQ-3: User and Outlet Access Mapping
- **User Story**: 
  As a Business Owner, I want to assign users to one or more outlets, so that employees can only view and perform transactions at their designated stores.
- **Acceptance Criteria**:
  - `WHEN a user assignment is created, THE SYSTEM SHALL insert a mapping record in the user_has_outlet table linking the user_id to the outlet_id.`
  - `IF a user attempts to access an outlet not mapped to them, THEN the system SHALL raise an access denied exception.`

### REQ-4: Secure API Reference with UUIDs
- **User Story**: 
  As a Flutter Mobile Developer, I want to reference database records using UUIDs in API calls, so that internal BIGINT primary keys are not exposed to the mobile app client.
- **Acceptance Criteria**:
  - `WHERE data is fetched by the mobile client, the system SHALL expose the uuid column and hide the BIGINT id column.`
  - `IF an API request attempts to query or mutate a record using an internal BIGINT ID, THEN the system SHALL reject the request.`

### REQ-5: Timestamp-based Soft Delete
- **User Story**: 
  As an Auditor, I want deleted records to be marked with a deletion timestamp instead of a boolean flag, so that I can trace exactly when a tenant, outlet, or user account was deactivated.
- **Acceptance Criteria**:
  - `WHEN a record in businesses, outlets, or users is flagged for deletion, THE SYSTEM SHALL set the deleted_at column to the current timestamp (TIMESTAMPTZ) and deleted_by to the actor's username.`
  - `WHILE querying active resources, the system SHALL filter out records where deleted_at is NOT NULL.`

### REQ-6: Row Level Security (RLS) Data Isolation
- **User Story**: 
  As a Tenant User, I want all database queries to automatically filter data by my business ID, so that there is zero risk of data leakage or unauthorized access to other tenants' data.
- **Acceptance Criteria**:
  - `WHILE a tenant user is authenticated, the system SHALL automatically apply Row Level Security (RLS) policies to filter all select/insert/update/delete operations by the user's business_id.`
  - `IF an unauthenticated or anonymous user attempts to access tenant-specific tables, THEN the system SHALL deny all access.`

## 3. Success Metrics
- **Data Isolation Integrity**: 100% data isolation verified by automated tests (zero cross-tenant leaks).
- **Security Coverage**: 100% of tenant-specific tables have RLS enabled.
- **API Security**: 0 internal database IDs (BIGINT) exposed in the API contract.

## 4. Constraints
- **Database Engine**: Harus menggunakan Supabase (PostgreSQL 17+).
- **Compatability**: Skema baru harus tetap melestarikan relasi dan data Mangkasir lama yang telah dimigrasikan.
- **Authentication**: Bergantung penuh pada Supabase Auth (`auth.users`).

## 5. Out of Scope
- Migrasi data transaksi penjualan legacy.
- Pendaftaran merchant otomatis via payment gateway (Merchant onboarding).
- Pembuatan visual/UI dashboard web admin untuk manajemen tenant.
