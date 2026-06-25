# 08 — Laporan

**Tahap:** 1 (MVP) · **Domain:** Reporting

## Tujuan
Menyediakan rekap penjualan dan kas untuk evaluasi & pembukuan sederhana. Berbeda dari Dashboard: laporan bersifat **periode + detail + bisa diekspor**.

## Ruang Lingkup
**Masuk MVP:**
- Penjualan harian
- Penjualan bulanan
- Laporan kas (mutasi & saldo)
- Ekspor (CSV/PDF minimal)

**Tidak masuk MVP:** laba-rugi akuntansi, per-outlet (Tahap 2), BI (Enterprise).

## Aktor & Hak Akses
| Laporan | Admin | Kasir |
|---------|:-----:|:-----:|
| Penjualan | ✅ | ❌ |
| Kas | ✅ | ❌ |

## Sumber Data
Semua laporan = query agregasi (read-only), tanpa tabel baru.

**Penjualan Harian** — kelompok per tanggal:
- jumlah transaksi, total omzet, total diskon, total HPP, **laba kotor** (omzet − HPP), metode bayar.

**Penjualan Bulanan** — kelompok per hari dalam bulan + total bulan, produk terlaris.

**Laporan Kas** — daftar `cash_transactions` periode + saldo awal/akhir + total in/out.

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| GET | `/reports/sales/daily?date=` | Rekap 1 hari + rincian transaksi |
| GET | `/reports/sales/monthly?month=` | Rekap per hari + total bulan |
| GET | `/reports/cash?from=&to=` | Mutasi kas + saldo |
| GET | `/reports/{type}/export?format=csv|pdf` | Ekspor |

## Aturan Bisnis
- Hanya order status=paid; void dipisah/dikecualikan.
- Laba kotor = Σ(price − cost_price)·qty dari `order_items` (gunakan harga modal snapshot bila ada; minimal pakai cost saat ini di MVP).
- Periode mengikuti timezone outlet.
- Angka laporan = sumber kebenaran; dashboard mengikutinya.

## Validasi & Edge Case
- Periode tanpa data → tampil 0 / kosong, bukan error.
- Rentang besar → paginasi/agregasi di DB, jangan tarik semua baris ke memori.
- Ekspor harus mencerminkan filter yang aktif.

## Acceptance Criteria
- [ ] Laporan harian & bulanan akurat dan cocok dengan kas.
- [ ] Laporan kas menampilkan saldo awal/akhir benar.
- [ ] Ekspor CSV/PDF berfungsi sesuai filter.

## Dependensi
- `04_POS`, `05_Kas`, `02_Produk`.
