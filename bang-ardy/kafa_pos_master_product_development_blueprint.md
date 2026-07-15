# KaFa POS Master Product Development Blueprint

Status: ACTIVE (Single Source of Truth)  
Version: 1.3  
Tanggal: 2026-03-12  
Produk: KaFa POS  
Kategori: Retail POS SaaS Platform  
Publisher: KaFa Technologies

Dokumen ini adalah acuan resmi untuk pengembangan KaFa POS dan satu-satunya referensi aktif di workspace.
Dokumen pendahulu sudah dinonaktifkan dan dihapus untuk mencegah ambiguity pembacaan oleh AI assistant.

---

## 0. AI Readability and Governance

### 0.1 Canonical Source

- Canonical human document: `Docs/kafa_pos_master_product_development_blueprint.md`
- Canonical machine-readable mirror: `Docs/kafa_pos_ai_context.json`
- Semua AI assistant wajib menggunakan dokumen canonical human sebagai sumber utama.
- File mirror JSON hanya ringkasan terstruktur yang harus selalu sinkron dengan dokumen utama.

### 0.2 AI Parsing Rules

- Gunakan nomor section sebagai anchor stabil (contoh: `9.25`, `11.9`, `15.13`, `21`, `22`).
- Jangan mengambil referensi dari dokumen yang sudah dihapus atau dari chat lama yang tidak tercermin di dokumen ini.
- Jika requirement belum tertulis di dokumen ini, perlakukan sebagai usulan, bukan scope aktif.
- Jika ada konflik antar interpretasi, ikuti isi eksplisit dokumen ini.
- Jika ada perubahan requirement baru dari owner produk, update dokumen ini terlebih dahulu sebelum implementasi skala besar.

### 0.3 Synchronization Protocol

- Setiap perubahan scope/aturan harus menaikkan `Version`.
- Setiap perubahan substansial harus update `kafa_pos_ai_context.json` pada perubahan yang sama.
- Perubahan yang menyentuh scope harus menjaga konsistensi lintas section: `Scope dan Boundary`, `Modul`, `Rules`, `Data Model`, `API Boundary`, `Roadmap dan QA`.

### 0.4 Machine-Readable Snapshot

```yaml
canonical_doc: Docs/kafa_pos_master_product_development_blueprint.md
canonical_ai_mirror: Docs/kafa_pos_ai_context.json
version: 1.3
status: active
language: id
retail_modules_total: 25
saas_modules_total: 8
extension_active:
  - b2b_warung_supply_network_v1
```

---

## 1. Tujuan Dokumen

Tujuan utama:
- Menjadi referensi tunggal untuk product, engineering, QA, dan operasional.
- Mendefinisikan scope final sistem retail + SaaS layer secara lengkap.
- Menetapkan aturan bisnis inti agar implementasi antar tim tetap konsisten.
- Menjadi dasar untuk ERD, API spec, desain Android offline sync, dan rencana rilis.

---

## 2. Product Vision dan Outcome

KaFa POS dibangun sebagai Retail Operating System yang sederhana namun kuat untuk bisnis retail modern di Indonesia.

Outcome yang ditargetkan:
- Operasional toko berjalan stabil harian.
- POS tetap usable walau internet tidak stabil.
- Laporan bisnis dapat dipakai untuk pengambilan keputusan.
- Platform dapat dipakai banyak merchant melalui model SaaS multi-tenant.

---

## 3. Target Market

Segmen utama:
- UMKM retail
- toko sembako
- minimarket kecil/menengah
- toko grosir
- toko elektronik kecil
- toko bahan bangunan kecil
- retail chain kecil
- retail umum lainnya

Target fase saat ini (eksekusi produk):
- Buyer utama: warung (mode simple)
- Seller utama: retail/grosir
- Model transaksi utama: B2B restock warung -> retail/grosir dalam coverage area

---

## 4. Prinsip Produk

Prinsip desain sistem:
- Lengkap untuk operasional retail nyata di Indonesia.
- Tidak dibuat sekompleks ERP enterprise.
- Online-first dan offline-capable (offline fokus di Android POS).
- Semua transaksi inti harus auditable.
- Semua data operasional retail wajib terikat ke `tenant_id`.

---

## 5. Scope dan Boundary

### 5.1 Masuk Scope

Modul operasional retail:
- business & outlet
- user, role, permission
- product, category, brand, SKU, barcode, foto
- multiple unit + conversion + pricing per unit
- customer & membership
- pricing & discount engine
- POS sales
- payment (cash/transfer/QRIS/card/e-wallet manual/split)
- inventory management
- purchase & supplier
- cash/store balance & shift
- expense management
- tax management (configurable)
- asset management
- reporting
- offline POS mode (Android)
- sync engine
- device management
- sales return
- purchase return
- supplier payment tracking sederhana
- customer credit/store credit sederhana
- B2B warung sourcing marketplace antar tenant dalam wilayah
- import/export data
- backup/recovery strategy

SaaS management layer:
- tenant management
- subscription plan management
- feature flags & entitlements
- usage limits
- subscription & billing sederhana
- payment collection bertahap
- super admin panel
- B2B network governance & matching wilayah

### 5.2 Tidak Masuk Scope Saat Ini

- ERP kompleks
- akuntansi double-entry penuh
- integrasi pajak resmi pemerintah secara langsung
- marketplace omnichannel eksternal
- workflow FnB/kitchen/meja
- loyalty points kompleks
- transfer stok antar outlet advanced
- approval workflow detail
- promo bundling kompleks
- dashboard AI/forecasting
- payroll/HR
- manufacturing
- marketplace billing
- revenue analytics kompleks
- affiliate system

---

## 6. Platform dan Arsitektur

### 6.1 Platform Utama

- Web Admin / Backoffice: manajemen master data, operasional backoffice, report, monitoring.
- Android POS App: transaksi kasir harian, pembayaran, struk, shift, offline sales.
- Backend API (Laravel): business logic, validation, auth, RBAC, tenant isolation, sync API.
- PostgreSQL: database utama transaksi.
- Redis: queue, cache, job processing.
- Object Storage: upload file (foto produk, invoice/nota lampiran, aset).

### 6.2 Logical Architecture

```text
Web Admin (Next.js) --------\
                              > Backend API (Laravel) -> PostgreSQL
Android POS (Kotlin) -------/                      \
                                               Redis + Queue
                                               Object Storage
```

Catatan:
- Web Admin dan Android POS sama-sama client ke Backend API.
- Android POS punya local database untuk offline mode.

### 6.3 Technology Stack

- Backend: Laravel + PHP
- Web Admin: Next.js + TypeScript
- Android POS: Kotlin + Jetpack Compose
- Database: PostgreSQL
- Cache/Queue: Redis
- File Storage: Object Storage

---

## 7. Konsep Multi-Tenant SaaS

Setiap bisnis adalah tenant terpisah.

Struktur logis:

```text
Platform
+-- Tenant / Merchant
    |-- Subscription
    |-- Outlets
    |-- Users
    |-- Devices
    |-- Products
    |-- Customers
    |-- Sales
    +-- Reports
```

Aturan inti multi-tenant:
- Semua tabel operasional retail wajib memiliki `tenant_id`.
- Semua query aplikasi wajib ter-scope `tenant_id`.
- Data lintas tenant tidak boleh bisa diakses.
- Audit log harus menyimpan tenant context.

---

## 8. Definisi Mode Bisnis

### 8.1 Simple POS Mode

Fokus:
- penjualan, pembayaran, struk, shift kasir, customer basic

Batasan:
- tanpa alur retail lanjutan yang kompleks
- tidak wajib menggunakan pembelian, inventory advanced, tax advanced

Default untuk warung:
- `track_stock` default `off` (opsional dinyalakan per produk)
- fitur pricing/member/tax advanced disederhanakan pada onboarding awal
- onboarding diprioritaskan cepat dan minim konfigurasi

### 8.2 Retail Mode

Fokus:
- seluruh modul retail operasional lengkap termasuk purchase, inventory movement, pricing rules, tax, expense, asset, reporting

Aturan:
- tenant memilih mode saat setup dan bisa ditingkatkan sesuai plan/fitur.
- mode retail/grosir disarankan memakai `track_stock` aktif untuk kontrol supply B2B.

---

## 9. Katalog Modul Retail (Final v2)

### 9.1 Business & Outlet Management

Ruang lingkup:
- profil bisnis, alamat usaha
- multi outlet/cabang
- mata uang, timezone
- pajak default
- template receipt/struk
- printer setting per outlet/device
- mode bisnis Simple POS/Retail

### 9.2 User, Role & Access Control

Ruang lingkup:
- login user
- role management
- permission management
- assign user ke outlet
- reset password
- audit login
- activity log user

Role baseline:
- owner
- admin
- manager
- cashier
- inventory staff

Contoh rule:
- cashier tidak boleh ubah harga produk
- manager bisa void transaksi
- inventory staff bisa stock adjustment

### 9.3 Product & Catalog Management

Ruang lingkup:
- CRUD produk
- kategori, brand
- SKU, barcode
- foto produk
- harga modal, harga jual dasar
- minimum stock
- status aktif/nonaktif
- track stock on/off
- stock item / non-stock item

### 9.4 Multiple Unit System

Ruang lingkup:
- master satuan
- satuan dasar produk (base unit)
- multiple satuan jual per produk
- konversi satuan
- harga per satuan
- barcode per satuan
- pembelian multi unit
- penjualan multi unit

Aturan inti:
- stok selalu disimpan dalam base unit
- transaksi boleh menggunakan unit non-base
- semua konversi harus tersimpan sebagai snapshot transaksi

### 9.5 Customer & Membership

Ruang lingkup:
- data customer
- no HP/email/alamat
- histori pembelian
- member tiers
- status aktif/nonaktif member
- lookup customer di POS
- total belanja customer

Tier contoh:
- regular
- silver
- gold
- platinum

### 9.6 Pricing & Discount Engine

Ruang lingkup:
- base price
- harga per unit
- quantity discount
- member tier discount
- special price
- promo period
- manual discount
- priority rule
- stackable/non-stackable policy

Aturan inti:
- qty discount dievaluasi di item level
- member discount dievaluasi di cart level
- hasil pricing tersimpan sebagai transaction snapshot

### 9.7 POS Sales System

Ruang lingkup:
- scan barcode
- cari produk
- pilih unit jual
- cart
- pilih customer/member
- auto discount
- manual discount sesuai permission
- checkout
- hold cart/draft sale
- reprint receipt
- void transaksi
- refund/retur penjualan

### 9.8 Payment System

Ruang lingkup:
- cash
- transfer bank
- QRIS
- card/EDC manual
- e-wallet manual
- split payment sederhana
- kembalian otomatis
- payment reference
- payment status

### 9.9 Inventory Management

Ruang lingkup:
- stok per outlet dan produk
- inventory balance
- inventory movement history
- minimum stock alert
- stock adjustment
- stock opname
- histori stok
- laporan stok

Aturan inti:
- semua perubahan stok wajib melalui inventory movement
- angka saldo stok adalah hasil agregasi movement

### 9.10 Purchase & Supplier Management

Ruang lingkup:
- supplier master
- pembelian barang
- item pembelian
- penerimaan barang
- harga modal tercatat
- pembelian multi unit
- retur pembelian
- histori pembelian
- status pembelian

### 9.11 Cash / Store Balance

Ruang lingkup:
- kas masuk/keluar
- saldo kas
- saldo per outlet
- buka/tutup kas
- shift kasir
- cash reconciliation
- selisih kas
- histori mutasi kas

### 9.12 Expense Management

Ruang lingkup:
- input pengeluaran
- kategori pengeluaran
- pengeluaran per outlet
- lampiran nota
- histori expense

Kategori contoh:
- listrik, air, internet, transport, gaji, maintenance, kebersihan, ATK

### 9.13 Tax Management

Ruang lingkup:
- tax master
- tax class per produk
- tax per item
- tax per transaksi
- inclusive/exclusive tax
- tax summary
- export rekap pajak

Aturan inti:
- tax engine configurable
- tidak hardcoded permanen

### 9.14 Asset Management

Ruang lingkup:
- daftar aset
- kategori aset
- nilai perolehan
- lokasi/outlet
- kondisi aset
- status aktif/nonaktif
- histori aset
- lampiran foto/invoice

### 9.15 Reporting System

Laporan wajib:
- Penjualan: harian, per outlet, per kasir, per produk, per kategori, per metode bayar, void/refund
- Inventory: stok saat ini, mutasi, barang menipis, hasil stock opname
- Purchase: pembelian per supplier, histori pembelian per produk
- Customer/Membership: customer aktif, penjualan per tier, customer paling aktif
- Promo/Pricing: total diskon, performa promo, rule paling sering dipakai
- Tax: total pajak per periode/outlet/produk/kategori
- Finance Summary: total penjualan, total pembelian, total expense, estimasi laba sederhana, saldo kas

### 9.16 Offline POS Mode (Android)

Ruang lingkup:
- local database
- offline transaction
- offline receipt printing
- local cart recovery
- local master data cache
- sync queue
- retry sync
- status online/offline

Prinsip:
- saat internet putus, POS tetap bisa transaksi penjualan
- offline scope fokus pada sales flow

### 9.17 Sync Engine

Ruang lingkup:
- pull master data
- push transaksi offline
- data versioning
- retry failed sync
- sync status
- sync logs
- conflict flagging basic

### 9.18 Device Management

Ruang lingkup:
- register device
- assign device ke outlet
- printer binding
- device status
- last sync monitoring
- last online monitoring

### 9.19 Sales Return

Ruang lingkup:
- retur penuh/sebagian
- alasan retur
- opsi kembali ke stok / tidak
- refund ke cash / metode lain sederhana

### 9.20 Purchase Return

Ruang lingkup:
- retur ke supplier
- alasan retur
- pengaruh ke stok
- histori retur pembelian

### 9.21 Supplier Payment Tracking (Sederhana)

Ruang lingkup:
- status bayar pembelian
- lunas/belum lunas
- histori pembayaran supplier
- settlement sederhana

### 9.22 Customer Credit / Store Credit (Sederhana)

Ruang lingkup:
- sale on credit sederhana
- outstanding balance customer
- settlement pembayaran customer
- histori pembayaran piutang sederhana

### 9.23 Import / Export Data

Ruang lingkup:
- import produk via CSV/Excel
- export laporan
- export stok
- export transaksi
- export customer/member

### 9.24 Backup / Recovery Strategy

Ruang lingkup:
- backup database server
- export data penting
- recovery plan
- basic recovery data lokal Android saat crash

### 9.25 B2B Warung Sourcing Marketplace (Internal)

Tujuan:
- tenant mode simple (warung) dapat restock langsung ke tenant retail/grosir terdekat dalam satu wilayah
- menciptakan siklus supply internal dalam ekosistem KaFa POS

Ruang lingkup:
- buyer warung melihat katalog seller retail/grosir berdasarkan wilayah/coverage area
- pencarian produk grosir, harga, minimum order, stok tersedia
- pembuatan pesanan dari warung ke seller
- seller melakukan approve/reject pesanan
- opsi fulfillment: dikirim atau ambil di tempat
- opsi pembayaran: cash, transfer, QRIS, metode lain yang diaktifkan seller
- pelacakan status pesanan buyer dan seller
- integrasi otomatis ke dokumen operasional saat order approved
- sistem membuat sales order di seller
- sistem membuat purchase order di warung
- saat barang diterima, stok seller berkurang dan stok warung bertambah
- histori transaksi B2B masuk ke reporting kedua pihak

---

## 10. Katalog Modul SaaS (Final v2.1)

### 10.1 Tenant Management

- registrasi merchant
- owner account
- tenant status
- suspend/activate tenant
- trial period
- tenant metadata

### 10.2 Subscription Plan Management

- definisi plan
- billing cycle monthly/yearly
- plan features
- plan limits
- upgrade/downgrade

Plan baseline:
- Starter: 1 outlet, 2 users, 1 device, POS basic
- Growth: 2 outlet, 5 users, inventory, purchase, membership
- Pro: multi outlet, tax, cash balance, expense, asset, advanced reports
- Enterprise: custom limits

### 10.3 Feature Flags & Entitlements

Contoh flags:
- `inventory_enabled`
- `purchase_enabled`
- `tax_enabled`
- `multi_outlet_enabled`
- `asset_module_enabled`
- `b2b_marketplace_enabled`
- `b2b_seller_enabled`
- `b2b_buyer_enabled`

### 10.4 Usage Limits

Contoh limits:
- `max_users`
- `max_outlets`
- `max_devices`
- `max_products` (opsional)

Validasi limit wajib terjadi saat create user/outlet/device.

### 10.5 Subscription & Billing

Ruang lingkup:
- subscription status
- billing period
- invoice generation
- payment records
- due date tracking
- grace period

Status subscription:
- `trialing`
- `active`
- `past_due`
- `suspended`
- `canceled`

### 10.6 Payment Collection

Metode:
- transfer bank
- QRIS
- payment gateway
- manual verification

Tahapan:
- tahap awal: invoice manual + verifikasi manual
- tahap lanjut: gateway + webhook pembayaran

### 10.7 Super Admin Panel

Ruang lingkup:
- daftar tenant
- monitoring subscription
- suspend/activate account
- manual plan override
- trial management
- billing monitoring
- usage monitoring

### 10.8 B2B Network Governance

Ruang lingkup:
- pengaturan enable/disable fitur B2B per plan atau tenant
- pengaturan coverage area default per tenant
- policy matching seller terdekat/satu wilayah
- policy visibilitas katalog antar tenant
- monitoring order B2B lintas tenant
- dispute tagging sederhana untuk pesanan bermasalah

---

## 11. Aturan Bisnis Inti (Wajib)

### 11.1 Multi Unit dan Konversi

- Setiap produk punya tepat satu `base_unit`.
- Semua saldo stok disimpan dalam `base_qty`.
- Item transaksi menyimpan:
  - `unit_id`
  - `qty`
  - `conversion_factor_to_base`
  - `base_qty_snapshot`
- Perubahan conversion factor tidak boleh mengubah histori transaksi lama.

### 11.2 Pricing Evaluation Order

Urutan evaluasi standar:
1. Ambil base price / unit price
2. Evaluasi special price (jika aktif)
3. Evaluasi qty discount (item-level)
4. Evaluasi member tier discount (cart-level)
5. Terapkan manual discount (sesuai permission)
6. Terapkan tax (inclusive/exclusive sesuai class)

Snapshot minimal per line item:
- harga awal
- rule yang terkena
- nilai diskon per rule
- harga setelah diskon
- tax amount
- final line total

### 11.3 Inventory Movement

Movement type minimal:
- purchase_in
- sale_out
- sales_return_in
- purchase_return_out
- adjustment_in
- adjustment_out
- stock_opname_gain
- stock_opname_loss

Aturan:
- Tidak boleh update stok final secara langsung tanpa movement record.
- Semua movement menyimpan referensi dokumen sumber.

### 11.4 Sales, Payment, Return, Refund

- Transaksi sale completed tidak boleh diubah nilai itemnya.
- Perubahan setelah completed dilakukan via void/refund/return.
- Split payment wajib menyimpan detail per metode.
- Refund harus punya relasi ke dokumen sale asal.

### 11.5 Cash Session dan Reconciliation

- Shift kasir wajib `open` sebelum checkout sale cash.
- Setiap shift menyimpan opening cash, expected cash, actual cash, selisih.
- Selisih kas wajib tercatat dengan alasan.

### 11.6 Tax

- Produk dipetakan ke tax class.
- Mendukung inclusive dan exclusive.
- Tax dihitung per item lalu direkap per transaksi.
- Snapshot tax disimpan pada saat transaksi.

### 11.7 Credit Tracking

- Customer credit menambah outstanding saat sale on credit.
- Settlement mengurangi outstanding.
- Outstanding tidak boleh negatif.

### 11.8 SaaS Entitlement Enforcement

- Fitur retail hanya aktif jika entitlements plan mengizinkan.
- Resource creation ditolak jika melebihi usage limits.
- Suspend tenant menonaktifkan akses operasi transaksi baru.

### 11.9 B2B Warung-to-Grosir Rules

- Buyer B2B v1 diprioritaskan untuk tenant mode simple (warung).
- Seller B2B adalah tenant retail/grosir yang mengaktifkan katalog B2B.
- Katalog seller hanya tampil ke buyer dalam coverage area yang valid.
- Buyer membuat order dari snapshot harga dan stok saat checkout B2B.
- Seller wajib approve atau reject order sebelum fulfillment.
- Approval order membuat dokumen operasional otomatis pada kedua tenant.
- Fulfillment `delivery` dan `pickup` harus menyimpan bukti waktu serah terima.
- Pembayaran B2B mendukung cash, transfer, QRIS, atau metode aktif seller.
- Stok buyer bertambah hanya setelah status penerimaan barang `received`.
- Pembatalan order hanya boleh pada status sebelum `ready_for_pickup` atau `shipped`.

### 11.10 Stock Enforcement Policy (Per Tenant/Outlet)

Mode kebijakan stok:
- `strict`: transaksi ditolak jika stok sistem kurang dari qty.
- `warning_only`: sistem memberi warning, transaksi tetap boleh lanjut.
- `allow_negative`: transaksi tetap boleh lanjut dan stok boleh minus di sistem.
- `backorder`: transaksi dicatat sebagai order pending, fulfillment saat stok siap.

Aturan implementasi:
- `allow_negative` wajib alasan dan audit log.
- `backorder` tidak membuat stock out final sampai barang diserahkan.
- kebijakan dapat diset per tenant atau per outlet.

Rekomendasi mode default:
- warung simple: `warning_only` atau `track_stock=off`.
- retail/grosir: `warning_only` sebagai default, `allow_negative` hanya role tertentu.

---

## 12. Status dan Lifecycle Dokumen

### 12.1 Sales

- `draft` -> `completed` -> (`voided` | `refunded_partial` | `refunded_full`)

### 12.2 Payments

- `unpaid` -> `partial` -> `paid` -> (`refunded_partial` | `refunded_full`)

### 12.3 Purchase

- `draft` -> `ordered` -> (`received_partial` | `received_full`) -> `closed`
- Jalur pembatalan: `draft|ordered` -> `canceled`

### 12.4 Purchase Return

- `draft` -> `approved` -> `completed` -> `closed`

### 12.5 Stock Opname

- `draft` -> `counting` -> `posted` -> `closed`

### 12.6 Subscription

- `trialing` -> `active` -> `past_due` -> (`active` | `suspended`) -> `canceled`

### 12.7 B2B Order

- `created` -> (`rejected` | `approved`) -> (`ready_for_pickup` | `shipped`) -> `received` -> `closed`
- Jalur pembatalan: `created|approved` -> `canceled`

### 12.8 Backorder Fulfillment

- `requested` -> `approved_backorder` -> (`partially_fulfilled` | `fulfilled`) -> `closed`
- Jalur pembatalan: `requested|approved_backorder` -> `canceled`

---

## 13. Numbering Strategy Dokumen

Format default:
- Sales invoice: `SAL-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Receipt: `RCT-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Purchase: `PUR-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Sales return: `SRT-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Purchase return: `PRT-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Expense: `EXP-{OUTLET}-{YYYYMMDD}-{SEQ}`
- Asset: `AST-{OUTLET}-{YYYYMMDD}-{SEQ}`
- B2B order: `B2B-{REGION}-{YYYYMMDD}-{SEQ}`
- B2B fulfillment: `B2F-{REGION}-{YYYYMMDD}-{SEQ}`

Aturan:
- Sequence unik per outlet per hari.
- Nomor dokumen immutable setelah generated.

---

## 14. Role dan Permission Baseline

### 14.1 Role Global

- owner
- admin
- manager
- cashier
- inventory staff

### 14.2 Permission Kritis

- `product.update_price`
- `sale.apply_manual_discount`
- `sale.void`
- `sale.refund`
- `inventory.adjust`
- `purchase.create`
- `cash.reconcile`
- `report.export`
- `settings.manage_tax`
- `settings.manage_roles`
- `sale.force_negative_stock`
- `sale.convert_to_backorder`
- `b2b.catalog.publish`
- `b2b.order.create`
- `b2b.order.approve`
- `b2b.order.reject`
- `b2b.order.fulfill`
- `b2b.order.receive`
- `b2b.order.force_approve_no_stock`

### 14.3 Baseline Access Matrix

- owner: full access tenant
- admin: semua operasional kecuali aksi khusus owner
- manager: operasional + approval terbatas + void/refund sesuai policy, termasuk override stok jika permission aktif
- cashier: POS sales/payment/shift tanpa ubah harga master
- inventory staff: inventory, stock opname, adjustment, purchase receiving

---

## 15. Data Model Blueprint (Entity Catalog)

### 15.1 Common Fields

Untuk tabel operasional:
- `id` (UUID/ULID)
- `tenant_id`
- `created_at`
- `updated_at`
- `created_by` (opsional sesuai domain)
- `updated_by` (opsional sesuai domain)

### 15.2 Master & Security

- businesses
- outlets
- users
- roles
- permissions
- role_permissions
- user_outlets
- activity_logs
- audit_logs

### 15.3 Product Domain

- categories
- brands
- units
- products
- product_units
- product_barcodes
- product_prices
- product_tax_classes

### 15.4 Customer & Membership

- customers
- member_tiers
- customer_memberships
- customer_credit_accounts
- customer_credit_transactions

### 15.5 Pricing & Promo

- pricing_rules
- pricing_rule_conditions
- pricing_rule_actions
- pricing_snapshots

### 15.6 Tax

- taxes
- tax_classes
- tax_class_mappings
- transaction_tax_lines

### 15.7 Sales & Payment

- sales
- sale_items
- sale_discounts
- sale_taxes
- payments
- payment_lines
- receipts
- held_carts
- sales_returns
- sales_return_items
- refunds

### 15.8 Purchase & Supplier

- suppliers
- purchases
- purchase_items
- goods_receipts
- purchase_returns
- purchase_return_items
- supplier_payments

### 15.9 Inventory

- inventory_balances
- inventory_movements
- stock_opnames
- stock_opname_items
- stock_adjustments

### 15.10 Cash, Expense, Asset

- cash_accounts
- cash_sessions
- cash_transactions
- expense_categories
- expenses
- asset_categories
- assets
- asset_histories

### 15.11 Device, Offline, Sync

- devices
- device_printers
- sync_logs
- sync_batches
- offline_transactions
- offline_queue_items

### 15.12 SaaS Layer

- tenants
- tenant_owners
- plans
- plan_features
- plan_limits
- subscriptions
- subscription_invoices
- subscription_payments
- tenant_feature_overrides
- tenant_usage_counters

### 15.13 B2B Commerce Network

- b2b_seller_profiles
- b2b_coverage_areas
- b2b_catalog_items
- b2b_catalog_prices
- b2b_orders
- b2b_order_items
- b2b_order_status_logs
- b2b_fulfillments
- b2b_shipment_addresses
- b2b_order_payments

---

## 16. API Boundary dan Contract Dasar

### 16.1 Domain Boundary

Domain API minimal:
- Auth & Tenant
- User/RBAC
- Master Data
- Pricing/Tax
- Purchase/Inventory
- Sales/Payment
- Cash/Expense/Asset
- Reports
- Offline Sync
- SaaS Billing & Entitlements
- B2B Marketplace Network

### 16.2 Response Standard

Format standar:

```json
{
  "success": true,
  "data": {},
  "meta": {},
  "errors": []
}
```

Untuk error validasi:

```json
{
  "success": false,
  "data": null,
  "meta": {},
  "errors": [
    { "code": "VALIDATION_ERROR", "field": "name", "message": "name is required" }
  ]
}
```

### 16.3 Idempotency

Endpoint kritis wajib mendukung idempotency key:
- post sale
- post payment
- post refund
- post sync push batch
- post b2b order
- post b2b order approve
- post b2b order receive

Tujuan: mencegah transaksi dobel saat retry.

---

## 17. Android Offline dan Sync Blueprint

### 17.1 Offline Scope

Boleh offline:
- sales transaction
- payment capture
- receipt printing
- cart recovery

Tidak wajib offline di tahap awal:
- perubahan master data besar
- konfigurasi pricing/tax admin
- B2B marketplace order warung

### 17.2 Local Storage

Local DB minimal menyimpan:
- cached master data penting
- draft cart
- completed offline sales
- sync queue

### 17.3 Queue Status

- `pending`
- `syncing`
- `synced`
- `failed`
- `conflict`

### 17.4 Conflict Handling Baseline

- Master data conflict: server version menang.
- Transaksi sale offline completed: dipertahankan, diverifikasi dengan idempotency key.
- Jika conflict, tandai `conflict` dan tampilkan di backoffice review.

### 17.5 Sync Observability

Data monitoring minimal:
- last sync at
- total pending queue
- total failed queue
- last error code/message
- retry count

---

## 18. Pembagian Tanggung Jawab Platform

### 18.1 Web Admin / Backoffice

- business & outlet
- user/role/permission
- category/brand/unit/product
- supplier & purchase
- inventory control
- pricing & tax setup
- customer/member management
- cash/expense/asset
- reports & exports
- audit log
- settings
- device/sync monitoring
- SaaS super admin (platform team)
- B2B seller catalog dan order management
- B2B buyer order monitoring

### 18.2 Android POS

- login kasir
- product search
- barcode scanning
- unit selection
- cart & checkout
- customer/member lookup
- pricing display
- payment
- receipt printing
- shift kasir
- transaksi harian
- offline sales & sync status
- B2B restock order untuk warung (online mode)

### 18.3 Backend

- validasi business rule
- tenant isolation
- RBAC enforcement
- pricing/tax calculation server-side guard
- inventory movement engine
- sync reconciliation
- audit trail persistence
- matching wilayah buyer-seller B2B
- orchestrasi dokumen lintas tenant untuk order B2B

---

## 19. Reporting Catalog Wajib

### 19.1 Sales Reports

- daily sales
- per outlet
- per cashier
- per product
- per category
- per payment method
- void/refund transactions

### 19.2 Inventory Reports

- current stock
- stock movement
- low stock
- stock opname result

### 19.3 Purchase Reports

- purchase by supplier
- purchase history by product

### 19.4 Customer/Membership Reports

- active customers
- sales by member tier
- top active customers

### 19.5 Promo/Pricing Reports

- total discount
- promo performance
- most used pricing rules

### 19.6 Tax Reports

- tax total by period
- tax by outlet
- tax by product/category

### 19.7 Finance Summary

- total sales
- total purchases
- total expenses
- simple profit estimate
- cash balance by outlet

### 19.8 B2B Commerce Reports

- B2B order volume per wilayah
- top seller grosir/retail
- top buyer warung
- on-time fulfillment rate
- B2B cancellation rate
- B2B gross merchandise value (GMV) internal

### 19.9 Stock Exception Reports

- daftar transaksi `allow_negative`
- aging backorder per outlet
- top produk dengan negative stock
- trend koreksi stok dari adjustment/opname

---

## 20. Non-Functional Requirements (NFR)

### 20.1 Performance Baseline

- product search POS local cache: target <= 300 ms
- checkout completion online: target <= 2 detik p95
- checkout completion offline: target <= 1 detik p95
- standard API read: target <= 1 detik p95

### 20.2 Reliability

- availability target backend: >= 99.5%
- retry mechanism untuk sync dan async jobs
- idempotency untuk endpoint transaksi kritis

### 20.3 Security

- authentication token/session aman
- role-permission enforcement di server
- tenant isolation di seluruh query
- audit log untuk aksi sensitif
- data sensitif terenkripsi saat transit (TLS)

### 20.4 Auditability

Audit minimal mencatat:
- siapa (`user_id`)
- tenant/outlet context
- aksi apa
- kapan
- entity sebelum/sesudah (untuk aksi sensitif)

### 20.5 Backup & Recovery

- backup database terjadwal
- retensi backup terdefinisi
- uji restore berkala
- prosedur recovery local Android data dasar

---

## 21. Development Roadmap (Final)

### Phase 0 - Discovery & Product Definition

Deliverable:
- final scope
- glossary
- user journey
- high-level acceptance criteria

### Phase 1 - Architecture & Data Design

Deliverable:
- architecture blueprint
- ERD inti
- status/lifecycle list
- API domain boundary

### Phase 2 - Backend Foundation

Deliverable:
- fondasi backend siap untuk semua modul

### Phase 3 - Master Data Modules

Deliverable:
- master data siap pakai transaksi

### Phase 4 - Pricing, Tax & Rules Engine

Deliverable:
- pricing & tax engine stabil

### Phase 5 - Inventory & Purchase

Deliverable:
- alur barang masuk/keluar siap

### Phase 6 - Sales, Payment & Receipt

Deliverable:
- core POS flow end-to-end siap

### Phase 7 - Cash, Expense, Asset & Credit

Deliverable:
- kontrol keuangan operasional dasar siap

### Phase 8 - Web Admin / Backoffice UI

Deliverable:
- web admin usable operasional

### Phase 9 - Android POS App (Online First)

Deliverable:
- Android POS online-first siap uji

### Phase 10 - Offline Mode & Sync

Deliverable:
- Android POS offline-capable

### Phase 11 - Reporting, Export & Operational Polish

Deliverable:
- laporan & export matang

### Phase 12 - QA, UAT & Launch Preparation

Deliverable:
- sistem siap pilot/launch

### Phase 13 - B2B Warung Supply Network (Extension)

Deliverable:
- katalog seller B2B aktif per wilayah
- order flow buyer -> seller -> fulfillment -> receive siap
- integrasi dokumen sales/purchase lintas tenant berjalan
- stock enforcement policy aktif per outlet (`strict|warning_only|allow_negative|backorder`)
- laporan B2B dasar tersedia
- pilot B2B di minimal satu wilayah

### SaaS Layer Delivery Stages

- Tahap 1: tenant architecture, plan definition, usage limits
- Tahap 2: subscription management, billing sederhana
- Tahap 3: merchant self-service billing
- Tahap 4: payment gateway integration
- Tahap 5: governance dan kontrol B2B network

---

## 22. MVP Scope yang Disarankan

MVP:
- business & outlet
- user & role dasar
- product/catalog
- units & product_units
- customers/member tiers
- pricing qty + member discount
- tax basic
- purchase basic
- inventory movement basic
- sales POS
- payment
- receipt
- cash shift basic
- web admin basic
- Android POS online-first

Post-MVP prioritas:
- offline mode
- return flows lengkap
- expenses
- assets
- supplier payment tracking
- customer credit sederhana
- reporting lanjutan
- B2B warung sourcing marketplace v1 (wilayah terbatas)

---

## 23. QA, UAT, dan Release Gates

### 23.1 Test Scenario Wajib

- pricing rules combinations
- multi-unit conversions
- tax calculations
- purchase -> inventory movement
- sales -> inventory movement
- return/refund flows
- cash reconciliation
- offline/online sync
- role/permission security
- import/export
- POS performance under normal load
- B2B order flow create/approve/fulfill/receive
- validasi filter seller berdasarkan wilayah
- konsistensi stok dan pembayaran lintas tenant pada order B2B
- validasi mode `strict|warning_only|allow_negative|backorder`
- validasi permission override stok + audit trail

### 23.2 UAT Minimum

- UAT dengan sample bisnis nyata dari segmen target.
- Semua critical severity bug harus fixed sebelum pilot.
- Semua laporan inti dapat diakses dan diexport sesuai kebutuhan dasar.

### 23.3 Go-Live Gate

Wajib siap:
- deployment checklist
- backup/recovery checklist
- training material dasar pengguna

---

## 24. Timeline Referensi (Estimasi)

Single developer:
- MVP: 4-6 bulan
- Operational system: 7-9 bulan
- Full SaaS + offline maturity: 9-12 bulan

Tim kecil (3 developer):
- MVP: 2-3 bulan
- Operational system: 4-6 bulan
- Full system: 6-8 bulan

Catatan:
- estimasi berubah sesuai scope creep, kualitas data awal merchant, dan kompleksitas integrasi pembayaran.
- jika extension B2B diaktifkan penuh, tambahkan buffer estimasi 1-2 bulan.

---

## 25. Future Roadmap (Di Luar Scope Saat Ini)

- stock transfer antar outlet (advanced)
- loyalty points
- promo bundling kompleks
- analytics dashboard lanjutan
- external marketplace integration

---

## 26. Glossary

- Tenant: entitas bisnis/merchant pelanggan KaFa POS.
- Outlet: cabang toko milik tenant.
- Base Unit: satuan dasar penyimpanan stok.
- Conversion Factor: pengali dari unit transaksi ke base unit.
- Inventory Movement: catatan perubahan stok berbasis event.
- Shift Kasir: sesi kas operasional kasir.
- Entitlement: hak akses fitur berdasarkan plan.
- Usage Limit: batas kuota resource tenant per plan.
- Sync Queue: antrean transaksi offline yang belum terkirim ke server.
- Warung Buyer: tenant simple yang melakukan pembelian restock B2B.
- Seller Grosir/Retail: tenant retail yang mempublikasikan katalog untuk buyer warung.
- Coverage Area: wilayah layanan seller untuk mem-filter visibilitas katalog.
- B2B Order: pesanan lintas tenant dari buyer warung ke seller grosir/retail.
- Stock Enforcement Mode: kebijakan transaksi saat stok sistem tidak cukup.
- Negative Stock: kondisi stok sistem minus yang diizinkan secara terkontrol.
- Backorder: order yang disetujui namun fulfillment menunggu ketersediaan stok.

---

## 27. Coverage Checklist (Anti-Missing)

Checklist ini memastikan seluruh area historis sudah terintegrasi.
Catatan: dokumen sumber lama sudah dihapus dari workspace dan hanya dipertahankan sebagai referensi jejak cakupan.

### 27.1 Cakupan dari Product Spec v1

- Product identity, vision, target market: covered
- Platform web + Android: covered
- Architecture overview + stack: covered
- Core modules: covered dan diperluas
- SaaS multi-tenant: covered
- Subscription plan examples: covered
- Operational flow + offline flow: covered
- Development phases: covered (diselaraskan ke final)
- Timeline dan future roadmap: covered

### 27.2 Cakupan dari Final v2 + v2.1

- Scope 24 modul retail: covered penuh
- Scope boundary in/out: covered penuh
- Phase 0-12 tasklist dan deliverables: covered
- MVP priority list: covered
- SaaS v2.1 modules + entities + staging: covered
- Device/sync/offline detail: covered
- Supplier payment + customer credit + import/export + backup/recovery: covered

### 27.3 Cakupan Extension B2B Warung Supply Network

- Scope module B2B internal antar tenant: covered
- Rule matching wilayah buyer-seller: covered
- Lifecycle order B2B: covered
- Data model B2B: covered
- API boundary B2B: covered
- Roadmap phase extension B2B: covered

---

## 28. Keputusan Acuan Implementasi

Keputusan final yang harus dipegang tim:
- Dokumen ini menjadi referensi utama pengembangan.
- Semua desain teknis turunan (ERD, API spec, mobile sync spec) harus traceable ke dokumen ini.
- Perubahan scope wajib melalui revisi versi dokumen ini.
- Fitur di luar scope tidak dikerjakan tanpa approval perubahan scope.
- Extension B2B warung supply network dijalankan bertahap dari wilayah pilot sebelum skala nasional.

---

## 29. Changelog

- v1.3 (2026-03-12): tetapkan target eksekusi warung + retail/grosir, tambah stock enforcement policy (strict/warning_only/allow_negative/backorder), update lifecycle, permission, report, roadmap, dan QA.
- v1.2 (2026-03-12): tambah AI Readability and Governance, tetapkan canonical source + machine mirror, dan sinkronisasi policy untuk human-AI consistency.
- v1.1 (2026-03-12): tambah extension B2B Warung Supply Network (scope, rules, data model, lifecycle, API boundary, roadmap, QA, reporting).
- v1.0 (2026-03-12): rilis awal master blueprint sebagai single source of truth.



