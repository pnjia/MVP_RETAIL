# 02 — Multi Outlet

**Tahap:** 2.0 · **Domain:** Core

## Tujuan
Mendukung lebih dari satu cabang/toko dengan stok, transaksi, dan laporan terpisah namun terpusat, plus transfer stok antar outlet.

## Ruang Lingkup
- Cabang (outlet)
- Transfer stok antar outlet
- Laporan per outlet & konsolidasi

## Data Model

**outlets**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| code | varchar UNIQUE | |
| name | varchar | |
| address | text | |
| timezone | varchar | |
| is_active | boolean | |

**Perubahan skema (scoping):** tambah `outlet_id` pada tabel transaksional & operasional: `orders`, `cash_transactions`, `stocks`, `stock_movements`, `warehouses`, `purchase_orders`. User punya relasi ke outlet (satu/banyak).

> Transfer antar outlet memakai mekanisme `stock_transfers` (Tahap 1.5) yang diperluas dengan outlet asal/tujuan.

## Alur Kerja
1. **Login** → user terikat outlet aktif; transaksi otomatis ber-`outlet_id`.
2. **Transfer stok** antar outlet: kirim dari A → terima di B (movement keluar/masuk), status terlacak.
3. **Laporan**: filter per outlet atau gabungan (konsolidasi) untuk owner.

## Aturan Bisnis
- Stok, kas, dan invoice **terisolasi per outlet** (nomor invoice unik per outlet, mis. prefix kode outlet).
- User hanya melihat data outlet yang ditugaskan (kecuali owner/super admin).
- Master data (produk, kategori) bisa shared global atau per-outlet — tetapkan kebijakan: **produk global, harga & stok per outlet** (disarankan).

## Acceptance Criteria
- [ ] Transaksi & stok tercatat per outlet dengan benar.
- [ ] Transfer stok antar outlet berfungsi & teraudit.
- [ ] Laporan tersedia per outlet dan konsolidasi.
- [ ] Akses user dibatasi sesuai outlet.

## Dependensi
- `Tahap 1` (semua transaksional), `Tahap 1.5/01_Inventory` (transfer/gudang), `03_User_Management`.
