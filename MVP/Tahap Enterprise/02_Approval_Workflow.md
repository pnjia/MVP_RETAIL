# 02 — Approval Workflow

**Tahap:** Enterprise · **Domain:** System / Process

## Tujuan
Menambahkan persetujuan berjenjang untuk aksi sensitif (PO besar, diskon di atas batas, void, penyesuaian stok besar) agar ada kontrol & akuntabilitas.

## Ruang Lingkup
- Definisi aturan approval (entitas + kondisi + level penyetuju)
- Pengajuan, persetujuan/penolakan, eskalasi
- Notifikasi ke penyetuju

## Data Model

**approval_rules**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| entity | varchar | 'purchase_order','discount','void','stock_adjustment' |
| condition | json | mis. `{amount_gte: 5000000}` |
| approver_role_id | FK roles | |
| level | int | urutan jenjang |

**approval_requests**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| entity / entity_id | | objek yang diajukan |
| requested_by | FK | |
| status | enum('pending','approved','rejected','cancelled') | |
| current_level | int | |
| created_at | | |

**approval_steps**: `request_id`, `level`, `approver_id`, `decision('approve','reject')`, `note`, `decided_at`.

## Alur Kerja
1. User melakukan aksi yang memicu rule (mis. PO ≥ Rp5jt) → objek masuk status `pending approval`, dibuat `approval_request`.
2. Penyetuju level 1 mendapat notifikasi → approve/reject (+catatan).
3. Bila multi-level, naik ke level berikut; semua approve → aksi dieksekusi (PO dikirim, diskon berlaku).
4. Reject → aksi dibatalkan, pemohon diberi tahu.

## Aturan Bisnis
- Objek dalam status pending tidak boleh dieksekusi sebelum approval lengkap.
- Pemohon tidak boleh menyetujui pengajuannya sendiri.
- Semua keputusan tercatat (akuntabilitas, terhubung audit log).

## Acceptance Criteria
- [ ] Aksi yang memenuhi kondisi otomatis butuh approval.
- [ ] Persetujuan berjenjang berjalan sesuai urutan level.
- [ ] Reject membatalkan aksi; approve mengeksekusi.

## Dependensi
- `Tahap 2.0/03_User_Management` (role & audit), `Tahap 1.5/03_Purchase`, `Tahap 1/04_POS`.
