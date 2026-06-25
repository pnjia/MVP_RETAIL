# 01 — CRM (Loyalty, Membership, Voucher, Gift Card)

**Tahap:** Enterprise · **Domain:** Customer / Marketing

## Tujuan
Meningkatkan retensi pelanggan lewat program loyalitas: poin, membership berjenjang, voucher, dan gift card.

## Ruang Lingkup
- Loyalty Point (kumpul & tukar)
- Membership (tier: silver/gold, benefit & harga member)
- Voucher (kode potongan)
- Gift Card (saldo prabayar)

## Data Model

**memberships**: `customer_id`, `tier`, `joined_at`, `points_balance`, `valid_until`.

**point_transactions**: `customer_id`, `type('earn','redeem','expire')`, `points`, `ref_order_id`, `created_at`.

**vouchers**: `code` UNIQUE, `type('percent','amount')`, `value`, `min_purchase`, `quota`, `used_count`, `start_at`, `end_at`, `is_active`.

**gift_cards**: `code` UNIQUE, `initial_balance`, `balance`, `status('active','used','expired')`, `expires_at`.
**gift_card_transactions**: `gift_card_id`, `type('topup','redeem')`, `amount`, `ref_order_id`.

## Alur Kerja
- **Earn poin**: order selesai → tambah poin = f(grand_total) sesuai aturan tier.
- **Redeem**: tukar poin jadi diskon/produk di POS → catat `redeem`.
- **Voucher**: input kode di POS → validasi (aktif, kuota, min purchase) → potong.
- **Gift card**: bayar pakai saldo gift card → kurangi `balance`.

## Aturan Bisnis
- Poin & saldo gift card adalah liabilitas — semua perubahan lewat transaksi (auditable), tak diedit langsung.
- Voucher: cek kuota & periode; satu kode tak melebihi `quota`.
- Poin bisa kedaluwarsa (`expire`) sesuai kebijakan.
- Harga member memakai `price_level` (lihat Tahap 1.5/04_Harga).

## Acceptance Criteria
- [ ] Poin bertambah saat belanja & bisa ditukar.
- [ ] Voucher & gift card divalidasi dan diterapkan benar di POS.
- [ ] Saldo/poin selalu rekonsiliasi dengan riwayat transaksinya.

## Dependensi
- `Tahap 1/06_Pelanggan`, `Tahap 1/04_POS`, `Tahap 1.5/04_Harga`.
