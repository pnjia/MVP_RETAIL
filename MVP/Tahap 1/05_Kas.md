# 05 — Kas (Cash Management)

**Tahap:** 1 (MVP) · **Domain:** Finance

## Tujuan
Melacak uang fisik di laci kasir: pemasukan (penjualan, modal awal) dan pengeluaran (beli galon, bensin, dll), serta saldo kas terkini agar bisa dicocokkan saat tutup toko.

## Ruang Lingkup
**Masuk MVP:**
- Kas masuk
- Kas keluar
- Saldo kas (real-time)
- (Disarankan) Buka & tutup shift kasir

**Tidak masuk MVP (Tahap 2):** kredit/piutang, hutang, multi-rekening bank.

## Aktor & Hak Akses
| Aksi | Admin | Kasir |
|------|:-----:|:-----:|
| Catat kas masuk/keluar manual | ✅ | ✅ |
| Lihat saldo | ✅ | ✅ |
| Hapus/koreksi entri | ✅ | ❌ |
| Tutup shift & lihat selisih | ✅ | ✅ |

## Data Model

**cash_transactions**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| type | enum('in','out') | |
| amount | decimal | selalu positif |
| category | varchar | 'sale','capital','expense','withdrawal' |
| description | text | |
| ref_type | varchar NULL | 'order' bila dari POS |
| ref_id | bigint NULL | |
| shift_id | FK NULL | |
| created_by | FK users | |
| created_at | timestamp | |

**cash_shifts** (disarankan)
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| user_id | FK | kasir |
| opening_balance | decimal | modal awal laci |
| closing_balance | decimal NULL | hitungan fisik akhir |
| expected_balance | decimal NULL | menurut sistem |
| difference | decimal NULL | selisih (lebih/kurang) |
| opened_at / closed_at | timestamp | |

## Alur Kerja

**Saat penjualan (otomatis)**
- Order tunai sukses → buat `cash_transactions` type=in, category=sale, ref ke order.

**Kas keluar manual**
1. Kasir/Admin input nominal + kategori + keterangan.
2. Saldo berkurang.

**Tutup shift**
1. Sistem hitung `expected_balance = opening + total_in − total_out`.
2. Kasir input hitungan uang fisik (`closing_balance`).
3. `difference = closing − expected` → tampilkan lebih/kurang.

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| GET | `/cash/balance` | Saldo saat ini |
| GET | `/cash/transactions?date=&type=` | Daftar mutasi |
| POST | `/cash/in` | `{amount, category, description}` |
| POST | `/cash/out` | idem |
| POST | `/cash/shifts/open` | `{opening_balance}` |
| POST | `/cash/shifts/{id}/close` | `{closing_balance}` |

## Aturan Bisnis
- Saldo = Σ(in) − Σ(out). Tidak diedit langsung.
- `amount > 0` selalu; arah ditentukan `type`.
- Kas masuk dari POS dibuat otomatis, **tidak** diinput ganda manual.
- Koreksi entri = buat entri pembalik (jangan hapus), kecuali Admin pada hari sama.

## Validasi & Edge Case
- Kas keluar > saldo → peringatkan (boleh tetap dicatat bila kebijakan mengizinkan).
- Tutup shift tanpa buka shift → tolak.
- Selisih besar saat tutup → highlight untuk ditinjau.

## Acceptance Criteria
- [ ] Penjualan tunai otomatis menambah kas masuk.
- [ ] Kas masuk/keluar manual tercatat dengan kategori.
- [ ] Saldo akurat & cocok dengan total mutasi.
- [ ] Tutup shift menampilkan selisih fisik vs sistem.

## Dependensi
- `01_Authentication`, terhubung otomatis dari `04_POS`. Dipakai `08_Laporan`.
