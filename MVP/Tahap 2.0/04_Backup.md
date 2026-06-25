# 04 — Backup & Restore

**Tahap:** 2.0 · **Domain:** System

## Tujuan
Melindungi data dari kehilangan (kerusakan disk, human error) dengan backup database terjadwal dan kemampuan restore.

## Ruang Lingkup
- Backup database (manual & terjadwal)
- Restore dari backup
- (Opsional) sinkronisasi ke cloud storage

## Pendekatan (lazy, andalkan tool native DB)
Gunakan utilitas bawaan DB, bukan menulis engine backup sendiri:
- PostgreSQL: `pg_dump` / `pg_restore`
- MySQL: `mysqldump`
Jadwalkan via cron. Simpan terenkripsi + retensi.

## Data Model

**backups**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| filename | varchar | |
| size_bytes | bigint | |
| storage | enum('local','cloud') | |
| status | enum('success','failed') | |
| type | enum('manual','scheduled') | |
| created_by | FK NULL | |
| created_at | timestamp | |

## Alur Kerja
1. **Backup terjadwal** (mis. harian 02:00) → dump DB → kompres → (opsional) upload cloud → catat metadata.
2. **Backup manual** dari menu Admin.
3. **Restore**: pilih file → konfirmasi keras (timpa data) → jalankan restore → verifikasi.

## Aturan Bisnis
- Restore = operasi berisiko: hanya super admin, butuh konfirmasi ganda, sebaiknya ke environment staging dulu.
- Retensi: simpan N backup terakhir (mis. 7 harian + 4 mingguan), hapus yang kedaluwarsa.
- File backup terenkripsi saat disimpan di cloud.
- Catat keberhasilan/kegagalan + notifikasi bila gagal.

## Acceptance Criteria
- [ ] Backup terjadwal berjalan otomatis & tercatat.
- [ ] Backup manual bisa diunduh.
- [ ] Restore mengembalikan data dengan benar (teruji di staging).
- [ ] Backup gagal memicu notifikasi.

## Dependensi
- Infrastruktur DB. `03_User_Management` (hak akses restore).
