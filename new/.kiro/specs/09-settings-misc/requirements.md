# Requirements Specification: Settings & References (09-settings-misc)

## 1. Introduction
Dokumen ini mendefinisikan kebutuhan untuk implementasi **Modul Settings & References** di MangRitel. Modul ini bertanggung jawab mengelola preferensi konfigurasi outlet (`settings`), tabel referensi geografis wilayah Indonesia (`provinces`, `cities`, `districts`, `villages`), serta data pelengkap utilitas sistem seperti FAQ, panduan panduan pengguna (`guides`), data hubungan pelanggan (`contact_us`), dan upload dokumen (`file_uploads`).

## 2. Requirements

### REQ-1: Settings Table Adaptation
- **User Story**: 
  As a Store Manager, I want to define specific configurations (e.g. receipt template, tax active, print options) for my outlet, so that the application behaves correctly for my branch.
- **Acceptance Criteria**:
  - `WHEN settings are saved, THE SYSTEM SHALL record them under the outlet_id, with standard snake_case audit columns.`
  - `THE SYSTEM SHALL enforce Row Level Security (RLS) so that settings are only readable and modifiable by users with authorized access to that outlet_id.`

### REQ-2: Public Contact Us Form Security
- **User Story**: 
  As a Prospect, I want to submit a contact us form, so that the sales team can contact me, while ensuring our messages are not readable by other prospects.
- **Acceptance Criteria**:
  - `WHEN a contact request is submitted, THE SYSTEM SHALL allow public/anonymous inserts into the contact_us table.`
  - `THE SYSTEM SHALL restrict SELECT access on the contact_us table to users with reports or owner/admin level permissions.`

### REQ-3: Geographic Reference Access (Static Data)
- **User Story**: 
  As a Cashier, I want to select the customer's province, city, and sub-district, so that address data is standardized.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL allow all authenticated users SELECT/read-only access to geographic tables (provinces, cities, districts, villages).`
  - `THE SYSTEM SHALL restrict INSERT, UPDATE, and DELETE operations on geographic tables to database administrators.`

### REQ-4: FAQs & Guides Access
- **User Story**: 
  As a Cashier, I want to read FAQs and step-by-step guides inside the application, so that I can resolve my operation problems without calling support.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL allow all authenticated users SELECT/read-only access to faqs and guides.`
  - `THE SYSTEM SHALL restrict write access (INSERT/UPDATE/DELETE) to system admins.`

### REQ-5: Affiliates & Referrals Level Security
- **User Story**: 
  As an Affiliate, I want my referral codes and user sign-up associations to be tracked securely, so that my commission is calculated correctly.
- **Acceptance Criteria**:
  - `THE SYSTEM SHALL protect affiliators and referrals with RLS policies, allowing authenticated users read access for sign-up matching, but restricting write access.`

## 3. Success Metrics
- **Akurasi Konfigurasi**: 100% pengaturan outlet terisolasi secara RLS per-cabang.
- **Keamanan Kontak**: 0% kebocoran data formulir pesan masuk `contact_us` ke pengguna umum.

## 4. Constraints
- **Database Engine**: Supabase (PostgreSQL 17+).

## 5. Out of Scope
- Integrasi API peta satelit interaktif (e.g. Google Maps SDK) di level database.
