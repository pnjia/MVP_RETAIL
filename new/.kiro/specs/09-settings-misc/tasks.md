# Tasks Specification: Settings & References (09-settings-misc)

## 1. Overview
Rencana kerja ini mendokumentasikan langkah-langkah peningkatan tabel preferensi `settings` dari baseline legacy Mangkasir ke MangRitel, aktivasi RLS pada seluruh tabel referensi statis (wilayah geografis, FAQ, panduan panduan), serta pengamanan formulir kontak masuk di Supabase.

## 2. Task List

### Tahap 1: Modifikasi Skema Preferensi (Settings Table Adaptation)
- [x] 1.1 Modifikasi tabel `settings`.
  - Putuskan foreign key legacy `FKmnsm95blhmn8yxjlwoasftxpi`.
  - Rename store_id -> outlet_id, dan sesuaikan kolom audit menjadi snake_case.
  - Tambahkan kolom `deleted_at` TIMESTAMPTZ, konversi boolean `deleted` ke `deleted_at`.
  - Pasang Foreign Key ke `outlets(id)` ON DELETE CASCADE.
  - _Requirements: REQ-1_

### Tahap 2: Aktivasi RLS & Deployment Kebijakan Keamanan (Geographic & Misc)
- [x] 2.1 Aktifkan RLS pada seluruh tabel referensi dan utilitas.
  - Jalankan `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;` untuk `settings`, `provinces`, `cities`, `districts`, `villages`, `faqs`, `guides`, `contact_us`, `file_uploads`, `affiliators`, `referrals`.
  - _Requirements: REQ-1, REQ-2, REQ-3, REQ-4, REQ-5_
- [x] 2.2 Pasang policies RLS untuk preferensi outlet (`settings`).
  - Buat policy SELECT/INSERT/UPDATE/DELETE berbasis `public.user_has_outlet_access(outlet_id)`.
  - _Requirements: REQ-1_
- [x] 2.3 Pasang policies RLS untuk data statis geografis & FAQ (`provinces`, `cities`, `districts`, `villages`, `faqs`, `guides`).
  - Buat policy SELECT terbuka untuk semua user terautentikasi (`auth.role() = 'authenticated'`).
  - Pastikan tidak ada policy INSERT/UPDATE/DELETE untuk user umum agar data tetap terkunci.
  - _Requirements: REQ-3, REQ-4_
- [x] 2.4 Pasang policies RLS untuk data kontak masuk (`contact_us`).
  - Buat policy INSERT terbuka untuk umum (`WITH CHECK (true)`).
  - Buat policy SELECT hanya terbuka bagi user yang memiliki role Owner/Administrator.
  - _Requirements: REQ-2_
- [x] 2.5 Pasang policies RLS untuk marketing/afiliasi (`affiliators`, `referrals`) dan upload (`file_uploads`).
  - Buat policy SELECT untuk `affiliators` dan `referrals` agar terbaca oleh user terautentikasi.
  - Buat policy SELECT/INSERT/UPDATE/DELETE untuk `file_uploads` bagi user terautentikasi.
  - _Requirements: REQ-5_

## 3. Quality Gates
- [x] Tabel preferensi `settings` ter-upgrade ke skema `outlet_id` dan RLS aktif.
- [x] RLS aktif dan mengamankan seluruh tabel referensi statis (wilayah geografis, FAQ, panduan).
- [x] Formulir kiriman pesan `contact_us` dapat di-insert secara publik namun data tertutup rapat hanya untuk Owner/Admin.
