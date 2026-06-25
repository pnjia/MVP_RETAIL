# 01 — Kredit (Piutang & Hutang)

**Tahap:** 2.0 · **Domain:** Finance

## Tujuan
Mengelola penjualan/pembelian yang tidak lunas tunai: piutang (pelanggan berhutang ke toko) dan hutang (toko berhutang ke supplier), termasuk cicilan.

## Ruang Lingkup
- Piutang (receivable) dari penjualan kredit
- Hutang (payable) dari pembelian kredit
- Pembayaran cicilan (sebagian / penuh)
- Jatuh tempo & status

## Data Model

**receivables** (piutang)
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| order_id | FK | sumber penjualan |
| customer_id | FK | |
| total | decimal | |
| paid | decimal | akumulasi bayar |
| remaining | decimal | total − paid |
| due_date | date | |
| status | enum('open','partial','paid','overdue') | |

**payables** (hutang) — struktur cermin, refer ke `purchase_order_id` & `supplier_id`.

**installment_payments**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| ref_type | enum('receivable','payable') | |
| ref_id | FK | |
| amount | decimal | |
| method | varchar | |
| paid_at | timestamp | |
| created_by | FK | |

## Alur Kerja

**Penjualan kredit**
1. Di POS, metode bayar = kredit → order tetap tersimpan, `paid_amount=0/DP`.
2. Buat `receivable` dengan `remaining` & `due_date`.

**Bayar cicilan**
1. Pilih piutang → input nominal.
2. Buat `installment_payment` → kas masuk (`Tahap 1/05_Kas`).
3. Update `paid`/`remaining`; jika 0 → status `paid`.

**Hutang ke supplier**: cermin, kas keluar saat bayar.

## Aturan Bisnis
- `remaining = total − paid` selalu konsisten; cicilan tak boleh > remaining.
- Lewat `due_date` & belum lunas → status `overdue`.
- Setiap pembayaran piutang membuat kas masuk; pembayaran hutang membuat kas keluar.
- Penjualan kredit tetap mengurangi stok seperti penjualan biasa.

## Acceptance Criteria
- [ ] Penjualan/pembelian kredit menghasilkan piutang/hutang.
- [ ] Cicilan mengurangi sisa & tercatat di kas.
- [ ] Status overdue otomatis berdasarkan jatuh tempo.
- [ ] Laporan piutang & hutang per pelanggan/supplier tersedia.

## Dependensi
- `Tahap 1/04_POS`, `Tahap 1/05_Kas`, `Tahap 1/06_Pelanggan`, `Tahap 1.5/02_Supplier`, `Tahap 1.5/03_Purchase`.
