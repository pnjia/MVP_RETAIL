# 02 — Supplier

**Tahap:** 1.5 · **Domain:** Master Data

## Tujuan
Mendata pemasok barang dan riwayat pembelian ke mereka. Prasyarat untuk modul Purchase (PO).

## Ruang Lingkup
- CRUD supplier
- Riwayat pembelian per supplier

## Data Model

**suppliers**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| code | varchar UNIQUE | |
| name | varchar | |
| contact_person | varchar NULL | |
| phone | varchar NULL | |
| email | varchar NULL | |
| address | text NULL | |
| payment_term | int NULL | tempo (hari), untuk hutang Tahap 2 |
| note | text NULL | |
| created_at/updated_at/deleted_at | | |

> Riwayat pembelian = query ke `purchase_orders WHERE supplier_id = ?`.

## API / Endpoint
| Method | Path |
|--------|------|
| GET | `/suppliers?search=` |
| GET | `/suppliers/{id}` |
| GET | `/suppliers/{id}/purchases` |
| POST/PUT/DELETE | `/suppliers/{id}` |

## Aturan Bisnis
- `code` unik. Soft delete; supplier dengan riwayat tidak dihapus permanen.
- `payment_term` dipakai nanti untuk jatuh tempo hutang (Tahap 2).

## Acceptance Criteria
- [ ] CRUD supplier berfungsi.
- [ ] Riwayat pembelian per supplier tampil.

## Dependensi
- `01_Authentication`. Dipakai oleh `03_Purchase`.
