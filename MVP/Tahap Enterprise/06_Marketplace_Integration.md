# 06 — Marketplace Integration (Shopee, Tokopedia, TikTok Shop)

**Tahap:** Enterprise · **Domain:** Integration / Omnichannel

## Tujuan
Menyinkronkan produk, stok, dan pesanan antara sistem (sebagai sumber kebenaran) dengan marketplace, agar jualan online & offline memakai satu stok.

## Ruang Lingkup
- Sinkronisasi produk & harga ke marketplace
- Sinkronisasi stok dua arah (cegah oversell)
- Tarik pesanan marketplace → jadi order di sistem
- Update status pesanan & resi

## Data Model

**marketplace_accounts**: `platform('shopee','tokopedia','tiktok')`, `shop_id`, `credentials(encrypted)`, `is_active`.

**marketplace_product_maps**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| product_id | FK | produk internal |
| account_id | FK | |
| external_product_id | varchar | id di marketplace |
| last_synced_at | timestamp | |

**marketplace_orders**: `account_id`, `external_order_id`, `order_id`(FK internal NULL), `status`, `raw_payload(json)`, `synced_at`.

## Alur Kerja
1. **Mapping**: kaitkan produk internal ↔ produk marketplace.
2. **Stok**: saat stok berubah (jual offline/online) → push update ke semua marketplace termapping (dengan buffer/safety agar tak oversell).
3. **Pesanan masuk**: poll/webhook marketplace → buat `order` internal (kurangi stok, sama seperti POS), simpan referensi.
4. **Fulfillment**: update status & nomor resi balik ke marketplace.

## Aturan Bisnis
- **Satu sumber stok** (sistem internal) untuk semua channel; sinkron harus idempoten & punya buffer anti-oversell.
- Hormati rate limit & format tiap platform (pakai adapter per platform).
- Pesanan marketplace mengurangi stok sama seperti penjualan biasa (movement type=sale).
- Konflik sinkron (mis. stok berubah bersamaan) diselesaikan dengan aturan jelas + log.

## Acceptance Criteria
- [ ] Produk & harga tersinkron ke marketplace.
- [ ] Stok konsisten lintas channel, oversell tercegah.
- [ ] Pesanan marketplace masuk otomatis sebagai order & mengurangi stok.
- [ ] Status & resi terkirim balik.

## Dependensi
- `05_API_Publik` (infra integrasi), `Tahap 1/02_Produk`, `Tahap 1/03_Persediaan`, `Tahap 1/04_POS`.
