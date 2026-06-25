# 01 — Authentication

**Tahap:** 1 (MVP) · **Domain:** Core

## Tujuan
Memastikan hanya pengguna sah yang bisa masuk sistem, dan setiap aksi terikat pada identitas + role-nya. Tanpa ini, modul lain tidak boleh jalan.

## Ruang Lingkup
**Masuk MVP:**
- Login (username/email + password)
- Logout
- Role: **Admin** dan **Kasir**
- Session / token management
- Ganti password

**Tidak masuk MVP (lihat Tahap 2 — User Management):**
- Permission granular per-fitur
- Multi-role, audit log lengkap, reset password via email

## Aktor & Hak Akses
| Aksi | Admin | Kasir |
|------|:-----:|:-----:|
| Login / Logout | ✅ | ✅ |
| Akses Dashboard penuh | ✅ | ❌ (terbatas) |
| CRUD Produk / Harga | ✅ | ❌ |
| Transaksi POS | ✅ | ✅ |
| Penyesuaian stok | ✅ | ❌ |
| Laporan keuangan | ✅ | ❌ |
| Kelola user | ✅ | ❌ |

## Data Model

**users**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | uuid / bigint PK | |
| name | varchar | Nama lengkap |
| username | varchar UNIQUE | Login |
| email | varchar UNIQUE NULLABLE | |
| password_hash | varchar | bcrypt/argon2, **bukan plaintext** |
| role | enum('admin','kasir') | |
| is_active | boolean | default true |
| last_login_at | timestamp NULL | |
| created_at / updated_at | timestamp | |

**sessions** (jika pakai token DB) atau gunakan JWT stateless.
| Field | Tipe |
|-------|------|
| id | uuid PK |
| user_id | FK users |
| token | varchar |
| expires_at | timestamp |
| ip_address | varchar |

## Alur Kerja

**Login**
1. User input username + password.
2. Sistem cari user aktif by username.
3. Verifikasi `password_hash` (constant-time compare).
4. Jika valid → buat session/JWT, set `last_login_at`, redirect by role.
5. Jika gagal → pesan generik "Username atau password salah" (jangan bocorkan field mana yang salah).

**Logout**
1. Hapus/blacklist token, hancurkan session.
2. Redirect ke halaman login.

## API / Endpoint
| Method | Path | Body | Response |
|--------|------|------|----------|
| POST | `/auth/login` | `{username, password}` | `{token, user{id,name,role}}` |
| POST | `/auth/logout` | — (token di header) | `204` |
| POST | `/auth/change-password` | `{old, new}` | `200` |
| GET | `/auth/me` | — | `{user}` |

## Aturan Bisnis
- Password disimpan **hash** (bcrypt cost ≥ 10 / argon2id). Tidak pernah plaintext.
- User `is_active=false` tidak boleh login.
- Token punya masa berlaku (mis. 8 jam kerja); refresh opsional.
- Setelah N kali gagal (mis. 5), kunci sementara / tambah delay (anti brute force).

## Validasi & Edge Case
- Username unik, case-insensitive.
- Password minimal 8 karakter.
- Login saat akun nonaktif → ditolak dengan pesan generik.
- Token kedaluwarsa → paksa login ulang, jangan crash.

## Acceptance Criteria
- [ ] Admin & Kasir bisa login dan diarahkan sesuai role.
- [ ] Password tersimpan ter-hash, tidak terlihat di DB.
- [ ] Logout mematikan sesi (token lama tidak bisa dipakai).
- [ ] Endpoint terproteksi menolak request tanpa token valid.

## Dependensi
- **Tidak ada** (modul paling dasar). Semua modul lain bergantung ke sini.
