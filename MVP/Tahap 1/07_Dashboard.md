# 07 — Dashboard

**Tahap:** 1 (MVP) · **Domain:** Reporting

## Tujuan
Memberi pemilik/admin gambaran cepat kondisi toko hari ini dalam satu layar, tanpa harus buka laporan detail.

## Ruang Lingkup
**Masuk MVP (kartu ringkasan):**
- Omzet hari ini
- Jumlah transaksi hari ini
- Produk terjual (jumlah unit / item terlaris)
- Stok hampir habis (daftar)

**Tidak masuk MVP:** grafik tren panjang, prediksi (Enterprise — Forecast/BI).

## Aktor & Hak Akses
| Komponen | Admin | Kasir |
|----------|:-----:|:-----:|
| Omzet & laba | ✅ | ❌ |
| Jumlah transaksi | ✅ | ✅ (miliknya) |
| Stok hampir habis | ✅ | ✅ |

## Data / Sumber
Dashboard **tidak punya tabel sendiri** — agregasi dari modul lain:
| Kartu | Query sumber |
|-------|--------------|
| Omzet hari ini | `SUM(grand_total)` dari `orders` status=paid, tanggal=hari ini |
| Jumlah transaksi | `COUNT(orders)` hari ini |
| Produk terjual | `SUM(qty)` & top-N dari `order_items` join hari ini |
| Stok hampir habis | `stocks.quantity ≤ min_stock` |

## Alur Kerja
1. Saat dibuka, load agregat hari berjalan (timezone outlet).
2. Auto-refresh ringan (mis. tiap 60 dtk) atau tombol refresh manual.
3. Klik kartu → menuju laporan/daftar detail terkait.

## API / Endpoint
| Method | Path | Response |
|--------|------|----------|
| GET | `/dashboard/summary?date=today` | `{omzet, tx_count, items_sold, top_products[]}` |
| GET | `/dashboard/low-stock` | `[{product, qty, min}]` |

## Aturan Bisnis
- Omzet hanya hitung order status=paid (void dikecualikan).
- Rentang "hari ini" mengikuti timezone & jam tutup toko (mis. shift lewat tengah malam → bisa pakai business day).
- Angka harus konsisten dengan modul Laporan.

## Validasi & Edge Case
- Belum ada transaksi → tampilkan 0, bukan error.
- Performa: gunakan index pada `orders.created_at`; agregasi ringan, hindari scan penuh tiap detik.

## Acceptance Criteria
- [ ] 4 kartu utama tampil & akurat untuk hari berjalan.
- [ ] Angka cocok dengan laporan penjualan harian.
- [ ] Daftar stok hampir habis bisa diklik ke produk.

## Dependensi
- `03_Persediaan`, `04_POS`. Selaras dengan `08_Laporan`.
