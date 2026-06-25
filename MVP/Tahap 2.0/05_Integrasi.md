# 05 — Integrasi (WhatsApp, Email, QRIS, Payment Gateway)

**Tahap:** 2.0 · **Domain:** System / Integration

## Tujuan
Menghubungkan sistem ke layanan eksternal: kirim struk via WhatsApp/Email, dan terima pembayaran non-tunai (QRIS / payment gateway).

## Ruang Lingkup
- WhatsApp (kirim struk/notifikasi)
- Email (struk, laporan)
- QRIS (pembayaran statis/dinamis)
- Payment Gateway (kartu, e-wallet, virtual account)

## Prinsip Desain
- Gunakan **provider pihak ketiga** (jangan bangun gateway sendiri): mis. Midtrans/Xendit/Doku untuk pembayaran & QRIS, WhatsApp Business API / penyedia gateway WA, SMTP/penyedia email.
- Bungkus tiap integrasi di balik antarmuka adapter + simpan kredensial di env/secret, bukan di DB plaintext.

## Data Model

**payment_channels**
| Field | Tipe |
|-------|------|
| id / name / provider / type('qris','va','ewallet','card') / is_active |

**integration_settings** (kredensial/konfigurasi, terenkripsi)
| Field | Tipe |
|-------|------|
| key / value(encrypted) / provider |

**payment_transactions** (status pembayaran online)
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id / order_id | FK | |
| provider | varchar | |
| external_ref | varchar | id dari gateway |
| amount | decimal | |
| status | enum('pending','paid','failed','expired') | |
| paid_at | timestamp NULL | |

**notification_logs**: channel('wa','email'), target, ref_order_id, status, sent_at.

## Alur Kerja

**QRIS / Gateway**
1. Di POS pilih metode non-tunai → buat charge ke provider → tampilkan QR/instruksi.
2. Tunggu callback/webhook provider → update `payment_transactions.status`.
3. Saat `paid` → selesaikan order & kas (kategori non-tunai).

**Kirim struk WA/Email**
1. Setelah order, opsi "kirim struk" → panggil provider dengan nomor/email pelanggan.
2. Catat di `notification_logs`.

## Aturan Bisnis
- Order baru lunas saat konfirmasi pembayaran (webhook) diterima — jangan andalkan klien saja.
- Webhook harus diverifikasi tanda tangannya & **idempoten** (callback ganda tak menggandakan order).
- Kredensial disimpan terenkripsi; tidak pernah di log.
- Timeout/expired pembayaran → order tidak diselesaikan, stok tidak berkurang.

## Acceptance Criteria
- [ ] Pembayaran QRIS/gateway terkonfirmasi via webhook & order diselesaikan.
- [ ] Webhook idempoten & terverifikasi.
- [ ] Struk terkirim via WhatsApp/Email dan tercatat.
- [ ] Kredensial tersimpan aman.

## Dependensi
- `Tahap 1/04_POS`, `Tahap 1/05_Kas`, `Tahap 1/06_Pelanggan`.
