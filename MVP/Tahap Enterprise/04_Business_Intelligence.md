# 04 — Business Intelligence Dashboard

**Tahap:** Enterprise · **Domain:** Analytics / Reporting

## Tujuan
Menyediakan analitik mendalam lintas waktu, outlet, produk, dan pelanggan untuk pengambilan keputusan strategis — di atas laporan operasional Tahap 1.

## Ruang Lingkup
- Tren penjualan multi-periode (YoY, MoM)
- Analisis profitabilitas (per produk/kategori/outlet)
- Segmentasi pelanggan (RFM), produk terlaris/lambat
- KPI: margin, AOV, retensi, perputaran stok

## Pendekatan Data
- Untuk volume besar, pisahkan analitik dari DB transaksional: bangun **tabel agregat / data warehouse** sederhana (mis. ringkasan harian per produk/outlet) yang diisi job terjadwal (ETL).
- Hindari query berat langsung ke tabel transaksi saat jam sibuk.

## Data Model (agregat/mart)

**fact_sales_daily**
| Field | Tipe |
|-------|------|
| date / outlet_id / product_id | dimensi |
| qty / revenue / cost / gross_profit / discount | measure |

**dim_product**, **dim_outlet**, **dim_customer** — tabel dimensi.

## Komponen Dashboard
| Widget | Sumber |
|--------|--------|
| Revenue & profit trend | fact_sales_daily |
| Top/slow products | agregasi qty/revenue |
| Margin per kategori | revenue − cost |
| RFM customer | recency/frequency/monetary dari orders |
| Stock turnover | COGS / rata-rata persediaan |

## Alur Kerja
1. ETL harian isi tabel fakta dari transaksi.
2. Dashboard query tabel agregat → render grafik interaktif (filter periode/outlet).
3. Drill-down ke detail bila perlu.

## Aturan Bisnis
- Angka BI harus rekonsiliasi dengan laporan operasional (sumber sama, hanya diagregasi).
- Definisi metrik dibakukan (mis. revenue = grand_total paid, profit = revenue − cost snapshot).

## Acceptance Criteria
- [ ] Dashboard menampilkan tren multi-periode & KPI utama.
- [ ] Filter per outlet/periode berfungsi cepat (pakai agregat).
- [ ] Angka konsisten dengan Laporan (Tahap 1).

## Dependensi
- `Tahap 1/08_Laporan`, `Tahap 2.0/02_Multi_Outlet`, semua data transaksi.
