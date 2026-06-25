# 03 — Forecast Penjualan (AI Demand Prediction & Auto Reorder)

**Tahap:** Enterprise · **Domain:** Analytics / AI

## Tujuan
Memprediksi permintaan ke depan dari data penjualan historis, lalu mengusulkan reorder otomatis agar stok tidak kehabisan/menumpuk.

## Ruang Lingkup
- Demand prediction per produk/outlet
- Auto reorder (usulan PO berdasarkan prediksi + lead time + safety stock)

## Pendekatan Bertahap (jangan langsung "AI berat")
1. **Baseline statistik dulu** (moving average / exponential smoothing / seasonal naive). Murah, transparan, sering cukup.
2. Naikkan ke model time-series (Prophet/ARIMA) bila baseline kurang.
3. ML/AI lanjutan hanya jika data & kebutuhan menuntut.
> Mulai dari yang sederhana; ukur akurasi (MAPE) sebelum menambah kompleksitas.

## Data Model

**demand_forecasts**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| product_id / outlet_id | FK | |
| period | date | bucket (harian/mingguan) |
| predicted_qty | decimal | |
| model | varchar | metode dipakai |
| generated_at | timestamp | |

**reorder_suggestions**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| product_id / outlet_id | FK | |
| current_stock | int | |
| reorder_point | int | safety stock + lead-time demand |
| suggested_qty | int | |
| status | enum('pending','accepted','dismissed') | |

## Alur Kerja
1. Job terjadwal tarik histori penjualan → hitung forecast per produk.
2. Hitung reorder point = (rata-rata demand × lead time) + safety stock.
3. Stok ≤ reorder point → buat `reorder_suggestion`.
4. Admin tinjau → terima (jadi draft PO ke supplier) atau abaikan.

## Aturan Bisnis
- Forecast adalah usulan, bukan aksi otomatis penuh — reorder butuh konfirmasi (atau approval, lihat modul Approval).
- Perhitungkan musiman & promo (lonjakan) agar tak salah prediksi.
- Simpan akurasi untuk evaluasi model.

## Acceptance Criteria
- [ ] Forecast per produk dihasilkan & tersimpan.
- [ ] Usulan reorder muncul saat stok di bawah titik pesan ulang.
- [ ] Usulan bisa dikonversi menjadi PO.

## Dependensi
- `Tahap 1/04_POS` (histori), `Tahap 1.5/03_Purchase`, `Tahap 1.5/02_Supplier`.
