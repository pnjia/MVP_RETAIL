# 03 — Persediaan (Stok)

**Tahap:** 1 (MVP) · **Domain:** Inventory

## Tujuan
Melacak jumlah barang yang tersedia secara akurat dan mencatat **setiap** perubahan stok agar bisa diaudit. Stok yang salah = uang hilang.

## Ruang Lingkup
**Masuk MVP:**
- Stok per produk
- Penyesuaian stok (manual adjustment: rusak, hilang, koreksi)
- Riwayat perubahan stok (stock movement / ledger)

**Tidak masuk MVP (Tahap 1.5):** stock opname, mutasi antar gudang, multi-gudang.

## Prinsip Inti
> **Stok = hasil penjumlahan seluruh movement, bukan angka yang diedit langsung.**
> Setiap perubahan (jual, beli, koreksi) menulis 1 baris movement. Ini membuat stok bisa diaudit dan tahan dari bug.

## Data Model

**stocks** (saldo cepat / cache, opsional)
| Field | Tipe |
|-------|------|
| product_id | FK PK |
| quantity | int |
| updated_at | timestamp |

**stock_movements** (sumber kebenaran)
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| product_id | FK | |
| type | enum('sale','purchase','adjustment','return') | |
| quantity | int | **+ masuk / − keluar** |
| balance_after | int | Saldo setelah movement |
| ref_type | varchar | 'order','adjustment',... |
| ref_id | bigint NULL | id transaksi terkait |
| note | text NULL | Alasan (untuk adjustment) |
| created_by | FK users | |
| created_at | timestamp | |

## Alur Kerja

**Penyesuaian Stok (Adjustment)**
1. Admin pilih produk, masukkan jumlah baru ATAU selisih (+/−).
2. Wajib isi alasan (rusak/hilang/koreksi/stok awal).
3. Sistem hitung selisih → tulis 1 baris `stock_movements` (type=adjustment).
4. Update `stocks.quantity`.

**Otomatis dari modul lain**
- POS menjual → movement `sale` (quantity negatif) saat transaksi sukses.
- Retur → movement `return` (positif).

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| GET | `/stocks?search=&low=true` | Saldo stok, filter hampir habis |
| GET | `/stocks/{productId}/movements` | Riwayat (ledger) per produk |
| POST | `/stocks/adjust` | `{product_id, new_qty atau delta, reason}` |

## Aturan Bisnis
- Stok hanya berubah lewat movement. **Tidak ada** edit langsung kolom quantity tanpa jejak.
- `quantity` boleh 0; cegah jadi negatif kecuali diizinkan (mis. backorder = tidak di MVP).
- Adjustment wajib alasan + tercatat siapa & kapan.
- Ambang "hampir habis" disetel per produk (`min_stock`) atau global (mis. ≤ 5).

## Validasi & Edge Case
- Jual melebihi stok → blok di POS (atau peringatan kuat) agar stok tak minus.
- Dua transaksi bersamaan atas produk sama → gunakan transaksi DB / lock baris agar saldo konsisten.
- Penyesuaian ke nilai sama (delta 0) → tidak buat movement.

## Acceptance Criteria
- [ ] Setiap penjualan & penyesuaian menghasilkan baris movement.
- [ ] Saldo stok = total movement (bisa direkonsiliasi).
- [ ] Riwayat menampilkan siapa, kapan, berapa, alasan.
- [ ] Produk hampir habis muncul di dashboard.

## Dependensi
- `02_Produk`. Dipakai oleh `04_POS`, `07_Dashboard`, `08_Laporan`.
