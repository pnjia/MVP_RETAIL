# 07 — Akuntansi Dasar (Jurnal, Buku Besar, Laba Rugi)

**Tahap:** Enterprise · **Domain:** Finance / Accounting

## Tujuan
Mengubah catatan operasional (penjualan, pembelian, kas) menjadi pembukuan akuntansi berbasis double-entry: jurnal otomatis, buku besar, dan laporan laba rugi / neraca dasar.

## Ruang Lingkup
- Chart of Accounts (CoA)
- Jurnal otomatis dari transaksi
- Buku besar (general ledger)
- Laporan: Laba Rugi, (opsional) Neraca, Arus Kas

## Konsep Inti: Double-Entry
> Setiap transaksi = minimal 2 baris jurnal; total debit = total kredit. Ini menjaga pembukuan selalu seimbang dan auditable.

## Data Model

**accounts** (CoA)
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id / code | varchar | mis. 1101 Kas, 4101 Penjualan, 5101 HPP |
| name | varchar | |
| type | enum('asset','liability','equity','revenue','expense') | |
| normal_balance | enum('debit','credit') | |

**journal_entries**
| Field | Tipe |
|-------|------|
| id / date / description / ref_type / ref_id / created_at |

**journal_lines**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| entry_id | FK | |
| account_id | FK | |
| debit | decimal | |
| credit | decimal | |

## Pemetaan Otomatis (contoh)
| Transaksi | Jurnal |
|-----------|--------|
| Penjualan tunai | D: Kas, K: Penjualan; D: HPP, K: Persediaan |
| Penjualan kredit | D: Piutang, K: Penjualan; D: HPP, K: Persediaan |
| Pembelian (terima barang) | D: Persediaan, K: Hutang/Kas |
| Bayar cicilan piutang | D: Kas, K: Piutang |
| Kas keluar (beban) | D: Beban, K: Kas |

## Alur Kerja
1. Event transaksi (order, penerimaan PO, kas, cicilan) → buat `journal_entry` + lines otomatis sesuai pemetaan.
2. Buku besar = agregasi `journal_lines` per akun.
3. Laba Rugi = Σ revenue − Σ expense (termasuk HPP) per periode.

## Aturan Bisnis
- Setiap entry harus balance (Σdebit = Σkredit) — tolak bila tidak.
- Jurnal otomatis konsisten dengan modul operasional (angka harus rekonsiliasi dengan Laporan).
- Periode akuntansi bisa dikunci (closing) agar data lampau tak berubah.
- HPP memakai harga modal snapshot dari transaksi.

## Acceptance Criteria
- [ ] Transaksi operasional menghasilkan jurnal balance otomatis.
- [ ] Buku besar per akun akurat.
- [ ] Laporan Laba Rugi periode benar & cocok dengan laporan penjualan.
- [ ] Periode bisa dikunci.

## Dependensi
- `Tahap 1/04_POS`, `Tahap 1/05_Kas`, `Tahap 1.5/03_Purchase`, `Tahap 2.0/01_Kredit`.
