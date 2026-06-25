# 03 — Purchase (Pembelian)

**Tahap:** 1.5 · **Domain:** Inventory / Procurement

## Tujuan
Mengelola pembelian barang ke supplier: membuat Purchase Order (PO), menerima barang, dan menambah stok secara terkontrol (bukan adjustment manual).

## Ruang Lingkup
- Purchase Order (PO)
- Penerimaan barang (Goods Receipt)
- Update harga modal otomatis saat penerimaan

## Data Model

**purchase_orders**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| po_no | varchar UNIQUE | |
| supplier_id | FK | |
| warehouse_id | FK | tujuan penerimaan |
| status | enum('draft','ordered','partial','received','closed','cancelled') | |
| subtotal / discount / tax / grand_total | decimal | |
| expected_date | date NULL | |
| created_by / created_at | | |

**purchase_order_items**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| po_id | FK | |
| product_id | FK | |
| qty_ordered | int | |
| qty_received | int | akumulasi diterima |
| cost_price | decimal | harga beli per unit |
| subtotal | decimal | |

**goods_receipts** + **goods_receipt_items** (penerimaan, bisa parsial)
| Field | Tipe |
|-------|------|
| id / po_id / received_by / received_at | |
| product_id / qty / cost_price | |

## Alur Kerja

1. **Buat PO** (draft) → pilih supplier, gudang, produk + qty + harga beli.
2. **Kirim/Order** → status `ordered`.
3. **Terima barang** (bisa bertahap):
   - input qty diterima per item,
   - tiap penerimaan → `stock_movements` (type=purchase, +qty) di gudang tujuan,
   - update `qty_received`; bila semua terpenuhi → status `received`/`closed`, parsial → `partial`.
4. **Update harga modal**: `products.cost_price` diperbarui (mis. harga terakhir atau moving average — pilih satu kebijakan & konsisten).

## Aturan Bisnis
- Stok bertambah **hanya** lewat penerimaan barang, bukan edit langsung.
- `qty_received` tidak boleh melebihi `qty_ordered` (kecuali kebijakan over-receipt diizinkan).
- PO `cancelled` tidak boleh diterima.
- Harga modal: tetapkan metode (last cost / moving average) di Settings.

## Acceptance Criteria
- [ ] PO bisa dibuat, dikirim, dan diterima (penuh & parsial).
- [ ] Penerimaan menambah stok via movement yang teraudit.
- [ ] Harga modal terupdate sesuai kebijakan.
- [ ] Riwayat pembelian muncul di supplier.

## Dependensi
- `02_Supplier`, `01_Inventory` (gudang), `Tahap 1/02_Produk`, `Tahap 1/03_Persediaan`.
