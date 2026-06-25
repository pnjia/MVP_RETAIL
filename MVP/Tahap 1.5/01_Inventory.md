# 01 — Inventory (Lanjutan)

**Tahap:** 1.5 · **Domain:** Inventory

## Tujuan
Memperluas persediaan dari sekadar saldo (Tahap 1) menjadi pengelolaan gudang penuh: stock opname, mutasi stok, dan multi-gudang. Membuat stok fisik dan sistem benar-benar cocok.

## Ruang Lingkup
- **Stock Opname** — perhitungan fisik berkala lalu koreksi ke sistem.
- **Mutasi Stok** — pindah stok antar gudang.
- **Gudang (Warehouse)** — lokasi penyimpanan (toko, gudang belakang).

## Data Model

**warehouses**
| Field | Tipe |
|-------|------|
| id | PK |
| name | varchar |
| type | enum('store','warehouse') |
| is_default | boolean |

> `stocks` & `stock_movements` (Tahap 1) ditambah kolom `warehouse_id`. Saldo jadi per-(produk, gudang).

**stock_opnames**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| warehouse_id | FK | |
| status | enum('draft','counting','done') | |
| note | text | |
| created_by / created_at / finalized_at | | |

**stock_opname_items**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| opname_id | FK | |
| product_id | FK | |
| system_qty | int | saldo sistem saat snapshot |
| counted_qty | int | hasil hitung fisik |
| difference | int | counted − system |

**stock_transfers** + **stock_transfer_items**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| from_warehouse_id / to_warehouse_id | FK | |
| status | enum('draft','sent','received') | |
| created_by / created_at | | |

## Alur Kerja

**Stock Opname**
1. Buat opname untuk satu gudang → sistem snapshot `system_qty` semua/ sebagian produk.
2. Petugas isi `counted_qty`.
3. Finalisasi → untuk tiap selisih buat `stock_movements` (type=adjustment, note='opname #id'), saldo dikoreksi.

**Mutasi Stok**
1. Buat transfer dari gudang A ke B (pilih produk + qty).
2. Kirim → movement keluar di A.
3. Terima di B → movement masuk di B. (Status `received`.)

## Aturan Bisnis
- Opname mengunci konsep: selisih selalu lewat movement (auditable), bukan overwrite.
- Saldo gudang tak boleh minus akibat transfer (cek ketersediaan saat kirim).
- Transfer belum diterima = stok "in transit" (tidak tersedia di A maupun B untuk dijual).

## Acceptance Criteria
- [ ] Saldo stok kini per gudang.
- [ ] Opname menghasilkan koreksi yang tercatat & bisa diaudit.
- [ ] Transfer memindah stok dengan benar antar gudang.

## Dependensi
- `Tahap 1/03_Persediaan`, `Tahap 1/02_Produk`.
