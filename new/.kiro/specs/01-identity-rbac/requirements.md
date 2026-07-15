# Requirements Specification: Identity & Role-Based Access Control (identity-rbac)

## ## Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi modul **Identity & Role-Based Access Control (RBAC)** di MangRitel. Modul ini bertujuan mengganti struktur peran statis (ENUM `role` pada tabel `users`) menjadi sistem otorisasi granular multi-level yang dinamis. Dengan RBAC baru, hak akses pengguna (Owner, Admin, Kasir, Gudang, dsb.) dapat diatur per-outlet atau secara global di tingkat bisnis (tenant) menggunakan tabel relasi di Supabase.

## ## Requirements

### REQ-1: Role & Permission Master Tables
- **User Story**: 
  As an Owner, I want the system to have separate tables for roles and permissions, so that I can map permissions to specific roles and assign multiple roles to users.
- **Acceptance Criteria**:
  - `WHEN a new role is created, THE SYSTEM SHALL generate a unique role record with a UUID, linked to a specific business_id (or NULL for system global roles).`
  - `IF a role name already exists within the same business_id, THEN the system SHALL reject the creation to maintain uniqueness.`
  - `WHERE a permission code is defined, the system SHALL enforce it to be unique globally (e.g. 'PRODUCT_CREATE', 'STOCK_ADJUST').`

### REQ-2: Junction Mappings for RBAC (M:N Relations)
- **User Story**: 
  As a Developer, I want to map permissions to roles and roles to users, so that I can easily verify which permissions a user has.
- **Acceptance Criteria**:
  - `WHEN a permission is assigned to a role, THE SYSTEM SHALL record it in the role_permissions table.`
  - `WHEN a role is assigned to a user, THE SYSTEM SHALL record it in the user_roles table with an optional outlet_id.`
  - `IF the outlet_id is NULL in user_roles, THEN the system SHALL treat the user's role as globally active across all outlets in their business.`
  - `IF the outlet_id is specified in user_roles, THEN the system SHALL treat the user's role as active only within that specific outlet.`

### REQ-3: Migration & Decommission of Legacy Role Enum
- **User Story**: 
  As a Developer, I want to migrate legacy user roles to the new RBAC structure and drop the legacy ENUM column, so that the database structure remains clean.
- **Acceptance Criteria**:
  - `WHEN migrating legacy users, THE SYSTEM SHALL auto-assign them to corresponding new roles (Owner, Administrator, Kasir) in user_roles.`
  - `WHEN the migration is completed, THE SYSTEM SHALL drop the legacy role column from the users table.`

### REQ-4: Granular Authorization & Security Policies (RLS)
- **User Story**: 
  As an Owner, I want the system to block unauthorized users from viewing or mutating data, so that our business records are safe.
- **Acceptance Criteria**:
  - `WHILE a user executes queries, the system SHALL check their permission codes via RLS policies or database functions before returning data or committing changes.`
  - `IF a user lacks the required permission code (e.g. 'SALE_VOID' to void a transaction), THEN the system SHALL deny the operation.`

## ## Success Metrics
- **Otorisasi Presisi**: 100% endpoint/mutasi sensitif terproteksi dengan permission check.
- **Kemudahan Integrasi**: Kecepatan verifikasi permission di database (RLS) beroperasi di bawah 10ms.
- **Clean Schema**: Kolom ENUM `role` legacy berhasil didekomisi sepenuhnya dari tabel `users`.

## ## Constraints
- **Database Engine**: Harus menggunakan Supabase (PostgreSQL 17+).
- **Session Auth**: Harus terintegrasi dengan UUID dari Supabase Auth (`auth.uid()`).

## ## Out of Scope
- Layar antarmuka (UI) manajemen role & permission dinamis di aplikasi Flutter (semua kustomisasi roles/permissions disetel dari seed database di iterasi awal).
- Hak akses hierarki bertingkat (Nested Roles / Inheritance Roles).
