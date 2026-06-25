# 04 — POS (Point of Sale)

**Tahap:** 1 (MVP) · **Domain:** Sales · **Modul paling kritikal**

## Tujuan
Tempat transaksi penjualan terjadi: kasir mencari produk, menyusun keranjang, menerima pembayaran, dan mencetak struk. Harus **cepat, akurat, dan tahan gangguan**.

## Ruang Lingkup
**Masuk MVP:**
- Cari produk (nama/SKU/barcode)
- Keranjang (tambah, ubah qty, hapus item)
- Diskon (per item & per transaksi)
- Pembayaran (tunai; hitung kembalian)
- Cetak struk
- Riwayat transaksi

**Tidak masuk MVP:** split payment, QRIS/kartu (Tahap 2 — Integrasi), multi-printer dapur (Tahap 1.5).

## Aktor & Hak Akses
| Aksi | Admin | Kasir |
|------|:-----:|:-----:|
| Buat transaksi | ✅ | ✅ |
| Beri diskon | ✅ | ✅ (mungkin dibatasi) |
| Void/batal transaksi | ✅ | ❌ / butuh approval |
| Lihat riwayat semua | ✅ | hanya miliknya |

## Data Model

**orders**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| invoice_no | varchar UNIQUE | nomor struk |
| customer_id | FK NULL | walk-in = null |
| cashier_id | FK users | |
| subtotal | decimal | sebelum diskon |
| discount_total | decimal | diskon transaksi |
| tax_total | decimal | bila ada pajak |
| grand_total | decimal | yang dibayar |
| paid_amount | decimal | uang diterima |
| change_amount | decimal | kembalian |
| payment_method | enum('cash',...) | |
| status | enum('paid','void') | |
| created_at | timestamp | |

**order_items**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| order_id | FK | |
| product_id | FK | |
| product_name | varchar | **disalin** (snapshot) |
| price | decimal | harga saat jual (snapshot) |
| qty | int | |
| discount | decimal | diskon per item |
| subtotal | decimal | (price·qty) − discount |

> **Snapshot harga & nama** penting: bila produk diedit nanti, struk lama tetap akurat.

## Alur Kerja

**Transaksi**
1. Kasir scan/cari produk → masuk keranjang (qty default 1).
2. Ubah qty / beri diskon item bila perlu.
3. Sistem hitung subtotal, diskon, total real-time.
4. (Opsional) pilih pelanggan.
5. Input pembayaran (tunai) → hitung kembalian.
6. Konfirmasi → sistem (dalam 1 transaksi DB):
   - simpan `orders` + `order_items`,
   - kurangi stok (`stock_movements` type=sale),
   - catat kas masuk (`05_Kas`),
   - generate `invoice_no`.
7. Cetak struk.

**Void / Batal**
- Hanya Admin. Membalik stok (movement return) & kas. Status order → `void`. Jangan hapus baris.

## API / Endpoint
| Method | Path | Keterangan |
|--------|------|-----------|
| POST | `/orders` | Buat transaksi (atomic) |
| GET | `/orders?date=&cashier=&page=` | Riwayat |
| GET | `/orders/{id}` | Detail + item |
| GET | `/orders/{id}/receipt` | Data/cetak struk |
| POST | `/orders/{id}/void` | Batalkan (Admin) |

## Aturan Bisnis
- Stok berkurang **hanya** saat transaksi sukses & dibayar; gunakan transaksi DB (all-or-nothing).
- `paid_amount ≥ grand_total` untuk tunai; kembalian = selisih.
- Diskon tidak boleh membuat total negatif.
- `invoice_no` berurutan & unik (mis. `INV-YYYYMMDD-0001`).
- Harga & nama produk di-snapshot ke `order_items`.

## Validasi & Edge Case
- Stok tidak cukup → blok / peringatkan sebelum bayar.
- Keranjang kosong → tidak bisa bayar.
- Printer mati → transaksi tetap tersimpan; struk bisa dicetak ulang dari riwayat.
- Listrik/aplikasi mati saat simpan → karena atomic, transaksi tersimpan utuh atau tidak sama sekali (tak ada stok berkurang tanpa order).

## Acceptance Criteria
- [ ] Scan → keranjang → bayar → struk dalam alur lancar tanpa reload berat.
- [ ] Stok & kas otomatis terupdate saat transaksi sukses.
- [ ] Struk bisa dicetak ulang dari riwayat.
- [ ] Void mengembalikan stok & kas dengan benar.
- [ ] Transaksi atomic: tidak ada kondisi setengah jadi.

## Dependensi
- `02_Produk`, `03_Persediaan`, `05_Kas`, `06_Pelanggan` (opsional).
