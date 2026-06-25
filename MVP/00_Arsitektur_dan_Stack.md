# 00 — Arsitektur & Stack Teknologi

Keputusan teknis fondasi proyek. Baca ini sebelum mulai implementasi modul mana pun.

## Konteks Keputusan

Dua kebutuhan ini menentukan seluruh arsitektur:

1. **POS wajib jalan offline** — toko harus tetap bisa transaksi saat internet mati.
2. **Multi-cabang segera** — 2–5 outlet dalam waktu dekat.

Konsekuensi: arsitektur **local-first dengan sync**, bukan web app online biasa.

## Prinsip

- **Boring & terbukti** di atas yang baru/hype. Prioritas = integritas data, bukan tren.
- **Append-only ledger** untuk stok & kas → bebas-konflik saat sync (lihat `Tahap 1/03_Persediaan`).
- **Stok dimiliki per outlet** (`outlet_id`) → tiap outlet hanya menulis barisnya sendiri → konflik sync minimal.
- **Jangan tulis sync engine sendiri** — pakai yang sudah teruji.
- **Hindari**: microservices, GraphQL, NoSQL, Kubernetes, framework eksperimental. Tidak ada nilainya untuk skala ini.

## Stack

| Layer | Pilihan | Alasan |
|-------|---------|--------|
| **DB lokal (mesin kasir)** | **SQLite** | Embedded, sangat stabil, jalan tanpa server. Sumber kebenaran saat offline. |
| **DB pusat (server)** | **PostgreSQL 16** | Konsolidasi semua outlet, laporan, backend integrasi. ACID kuat, `decimal` untuk uang. |
| **Sync engine** | **PowerSync** (alternatif: ElectricSQL) | Dibuat khusus untuk Postgres ⇄ SQLite offline-first. Resolusi konflik & antrian sudah ditangani. |
| **Shell app kasir** | **Tauri 2** (web UI + Rust) | Ringan (untuk PC kasir murah), stabil, akses USB printer native. *Fallback paling matang: Electron.* |
| **Frontend** | **React 18 + TypeScript + Tailwind + shadcn/ui** | Sama untuk app kasir & dashboard admin. TS cegah bug uang/qty. |
| **Backend pusat** | **Laravel 11** (alternatif: NestJS jika tim TS) | Auth, role/permission, laporan konsolidasi, webhook, integrasi. |
| **Auth** | **Laravel Sanctum** → **Spatie Permission** (Tahap 2) | Token; berkembang dari role tetap ke permission granular. |
| **Queue & cache** | **Redis** (MVP boleh database queue dulu) | Webhook pembayaran, kirim WA/email, backup terjadwal, sync marketplace. |
| **Cetak struk** | **ESC/POS** via Tauri (USB native) | Lebih andal daripada WebUSB browser. Thermal 58/80mm. |
| **Deploy** | **1 VPS + Docker Compose** | Postgres + PowerSync + Laravel + Redis. Cukup untuk beberapa cabang; scale saat perlu. |

**Kapan pilih NestJS + Prisma daripada Laravel:** hanya jika tim lebih kuat di TypeScript dan ingin satu bahasa ujung-ke-ujung. Sama stabil, tapi lebih banyak boilerplate untuk MVP.

## Arsitektur (gambaran)

```
┌─────────────── OUTLET A ───────────────┐   ┌─────────────── OUTLET B ───────────────┐
│  App Kasir (Tauri + React)             │   │  App Kasir (Tauri + React)             │
│  └── SQLite (lokal, jalan offline)     │   │  └── SQLite (lokal, jalan offline)     │
└──────────────────┬─────────────────────┘   └──────────────────┬─────────────────────┘
                   │  sync saat online (PowerSync)               │
                   └───────────────────┬─────────────────────────┘
                                       ▼
                        ┌──────────── SERVER PUSAT (VPS) ────────────┐
                        │  PowerSync  ·  PostgreSQL  ·  Laravel API  │
                        │  Redis (queue)  ·  Laporan konsolidasi     │
                        │  Integrasi: pembayaran, WA, marketplace    │
                        └────────────────────────────────────────────┘
```

## Strategi Bertahap (peredam risiko utama)

Sync offline multi-outlet adalah **satu-satunya bagian berisiko tinggi**. Cara meredamnya, selaras dengan tahapan dokumen:

1. **Tahap 1 (sekarang):** bangun app kasir **local-first, SQLite, fully offline, per-outlet**. Belum perlu sync selama cabang ke-2 belum buka. Satu outlet offline = tidak ada masalah distributed.
2. **Tahap 2 (Multi Outlet):** aktifkan PowerSync. Karena data sudah **append-only + `outlet_id`**, ini "menyalakan sync", bukan menulis ulang aplikasi.

Hasilnya: kebutuhan offline didapat sejak hari 1, kompleksitas sync ditunda sampai benar-benar ada 2 outlet. Jalur paling aman untuk timeline MVP.

## Catatan Implementasi yang Menyusul

Saat masuk Tahap 2, tambahkan ke skema setiap tabel tersinkron:
- `outlet_id` / `device_id` — asal data.
- `synced_at` (nullable) — penanda sudah tersync.
- Tombstone (`deleted_at`) untuk delete agar terpropagasi, bukan hard delete.

Detail ini ditambahkan ke dokumen modul terkait saat implementasi sync dimulai.
