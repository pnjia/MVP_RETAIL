# 05 — Multi Printer

**Tahap:** 1.5 · **Domain:** System

## Tujuan
Mendukung lebih dari satu printer dan tujuan cetak berbeda: struk kasir untuk pelanggan, dan tiket dapur/bar untuk pesanan yang perlu disiapkan.

## Ruang Lingkup
- Printer kasir (struk)
- Printer dapur/bar (tiket pesanan, jika diperlukan)
- Konfigurasi printer & pemetaan kategori → printer

## Data Model

**printers**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| name | varchar | "Kasir 1", "Dapur" |
| type | enum('receipt','kitchen','label') | |
| connection | enum('usb','network','bluetooth') | |
| address | varchar | IP/port atau device id |
| paper_width | int | 58/80 mm |
| is_active | boolean | |

**print_routes** (kategori produk → printer dapur)
| Field | Tipe |
|-------|------|
| category_id | FK |
| printer_id | FK |

## Alur Kerja
1. **Struk kasir**: setelah order sukses → cetak ke printer `type=receipt` default.
2. **Tiket dapur**: kelompokkan item per printer sesuai `print_routes` (mis. minuman → bar, makanan → dapur), cetak tiket terpisah berisi qty, catatan, nomor order.
3. Cetak ulang dari riwayat bila perlu.

## Aturan Bisnis
- Kegagalan cetak **tidak** membatalkan transaksi (order tetap tersimpan).
- Item tanpa rute dapur tidak dikirim ke printer dapur.
- Format struk dapat dikonfigurasi (logo, header/footer, lebar kertas).

## Validasi & Edge Case
- Printer offline → antrekan / tampilkan notifikasi, sediakan tombol cetak ulang.
- Lebar kertas berbeda → layout menyesuaikan 58/80mm.

## Acceptance Criteria
- [ ] Bisa daftarkan >1 printer dengan tipe & koneksi berbeda.
- [ ] Struk kasir & tiket dapur tercetak ke printer yang benar.
- [ ] Gagal cetak tidak menghilangkan transaksi; cetak ulang tersedia.

## Dependensi
- `Tahap 1/04_POS`, `Tahap 1/02_Produk` (kategori untuk routing).
