# 03 — User Management

**Tahap:** 2.0 · **Domain:** Core / System

## Tujuan
Mengubah role tetap (Admin/Kasir di Tahap 1) menjadi sistem role & permission fleksibel, dengan audit log untuk akuntabilitas.

## Ruang Lingkup
- Role (dinamis, bisa dibuat)
- Permission granular per-fitur
- Audit log (siapa melakukan apa, kapan)

## Data Model

**roles**
| Field | Tipe |
|-------|------|
| id / name / description | |

**permissions**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| code | varchar UNIQUE | `product.create`, `order.void`, `report.view` |
| group | varchar | pengelompokan UI |

**role_permissions** (pivot): `role_id`, `permission_id`.
**user_roles** (pivot, multi-role opsional): `user_id`, `role_id`.

**audit_logs**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| user_id | FK | |
| action | varchar | 'create','update','delete','void','login' |
| entity | varchar | tabel/modul |
| entity_id | bigint NULL | |
| changes | json NULL | before/after |
| ip_address | varchar | |
| created_at | timestamp | |

## Alur Kerja
1. Admin buat role → centang permission.
2. Assign role ke user.
3. Setiap request cek permission (middleware/guard) sebelum eksekusi.
4. Aksi penting (CRUD master, void, penyesuaian stok, pembayaran) ditulis ke `audit_logs`.

## Aturan Bisnis
- Default role bawaan (Admin = semua permission, Kasir = subset) tidak boleh terhapus.
- Cek izin di **backend** (jangan hanya sembunyikan tombol di UI).
- Audit log **append-only**, tidak bisa diedit/dihapus pengguna biasa.

## Acceptance Criteria
- [ ] Bisa buat role baru & atur permission.
- [ ] Endpoint menolak aksi tanpa permission yang sesuai.
- [ ] Audit log mencatat aksi penting lengkap dengan pelaku & waktu.

## Dependensi
- `Tahap 1/01_Authentication`. Mendukung `02_Multi_Outlet`.
