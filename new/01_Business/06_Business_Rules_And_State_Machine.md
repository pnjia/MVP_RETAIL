---
id: business-rules
title: Business Rules And State Machine
type: rule
parent: domain-analysis
tags: rule, state
version: 1.0
---

# Tahap 6 — Business Rules & State Machine

## Tujuan

Tahap ini mendefinisikan:

- lifecycle entity
- status
- transisi
- invariant
- business rule

Tahap ini merupakan "kontrak bisnis".

---

# Entity Lifecycle

Saya mulai dari entity paling penting.

---

# 1. Product

```text
Draft

↓

Active

↓

Inactive

↓

Archived
```

Rule

```
Draft
    ↓
Active

Active
    ↓
Inactive

Inactive
    ↓
Active

Inactive
    ↓
Archived
```

Tidak boleh

```
Archived

↓

Active
```

---

Business Rule

- Produk Draft tidak dapat dijual.
- Produk Archived tidak muncul.
- Produk Active dapat dijual.

---

# 2. Purchase Order

Lifecycle

```text
Draft

↓

Approved

↓

Receiving

↓

Completed
```

atau

```text
Draft

↓

Cancelled
```

atau

```text
Approved

↓

Cancelled
```

---

Business Rule

Draft

✓ Edit

✓ Delete

---

Approved

✓ Tidak boleh edit item

---

Completed

✓ Read Only

---

Cancelled

✓ Tidak boleh diaktifkan kembali

---

# 3. Receiving

Lifecycle

```text
Draft

↓

Receiving

↓

Completed
```

Rule

Completed

↓

Create Stock Movement

↓

Update Inventory

---

# 4. Stock Movement

Stock Movement tidak memiliki edit.

```text
Created

↓

Applied
```

atau

```text
Created

↓

Cancelled
```

Business Rule

Applied

↓

Tidak boleh diubah.

---

# 5. Stock Opname

```text
Draft

↓

Counting

↓

Review

↓

Approved

↓

Completed
```

Rule

Review

↓

Hitung Selisih

↓

Adjustment

---

# 6. Sales Transaction

Lifecycle

```text
Cart

↓

Checkout

↓

Paid

↓

Completed
```

atau

```text
Checkout

↓

Cancelled
```

---

Business Rule

Cart

↓

boleh edit

Paid

↓

stok berkurang

↓

cash bertambah

↓

invoice dibuat

↓

report bertambah

---

Completed

↓

immutable

---

# 7. Payment

Lifecycle

```text
Pending

↓

Paid
```

atau

```text
Pending

↓

Failed
```

atau

```text
Pending

↓

Cancelled
```

---

Rule

Paid

↓

Tidak boleh diubah.

---

# 8. Cash Session

Lifecycle

```text
Opened

↓

Operating

↓

Closing

↓

Closed
```

Rule

Closed

↓

Tidak boleh ada transaksi baru.

---

# 9. Customer

Lifecycle

```text
Active

↓

Inactive
```

Tidak perlu delete.

Karena history transaksi harus tetap ada.

---

# 10. Supplier

Sama.

```text
Active

↓

Inactive
```

---

# State Transition Matrix

| Entity       | Draft   | Active    | Completed | Cancelled |
| ------------ | ------- | --------- | --------- | --------- |
| Product      | ✓       | ✓         | -         | -         |
| Purchase     | ✓       | ✓         | ✓         | ✓         |
| Receiving    | ✓       | -         | ✓         | -         |
| Sale         | Cart    | Paid      | Completed | Cancelled |
| Payment      | Pending | Paid      | -         | Failed    |
| Cash Session | Open    | Operating | Closed    | -         |

---

# Global Business Invariants

Ini aturan yang **tidak boleh dilanggar oleh sistem**.

## Inventory

```
Semua perubahan stok
HARUS

membuat Stock Movement.
```

Tidak boleh ada update qty secara langsung.

---

## Sales

```
Sale Paid

↓

Reduce Stock

↓

Cash Transaction

↓

Report
```

Urutan ini wajib.

---

## Purchase

```
Receiving

↓

Stock

↓

Cost Update
```

---

## Product

SKU unik per outlet.

---

## Finance

Cash Session yang sudah Closed

↓

tidak boleh menerima transaksi.

---

## Reporting

Report tidak boleh menjadi sumber data.

Report hanya membaca.

---

# Domain Event Matrix

| Event            | Trigger            |
| ---------------- | ------------------ |
| ProductCreated   | Save Product       |
| ProductActivated | Activate Product   |
| PurchaseApproved | Approve PO         |
| GoodsReceived    | Complete Receiving |
| StockAdjusted    | Adjustment         |
| SaleCompleted    | Payment Success    |
| PaymentReceived  | Payment            |
| ShiftClosed      | Closing Shift      |

---

# Cross Domain Rules

## Penjualan

```
Sale

↓

Inventory

↓

Finance

↓

Reporting
```

---

## Pembelian

```
Purchase

↓

Inventory

↓

Finance
```

---

## Retur

```
Return

↓

Inventory

↓

Finance
```

---

## Opname

```
Opname

↓

Adjustment

↓

Inventory

↓

Reporting
```

---

# Permission by State

Contoh

Purchase

| State     | Edit | Delete | Approve |
| --------- | ---- | ------ | ------- |
| Draft     | ✓    | ✓      | ✓       |
| Approved  | ✗    | ✗      | ✗       |
| Completed | ✗    | ✗      | ✗       |
| Cancelled | ✗    | ✗      | ✗       |

---

## Summary

- Mendefinisikan lifecycle dan state transitions untuk entitas-entitas utama seperti Product, Purchase Order, Receiving, Stock Movement, Sales Transaction, Payment, dan Cash Session.
- Merumuskan Global Business Invariants yang tidak boleh dilanggar (misalnya setiap perubahan stok harus tercatat di Stock Movement).
- Mengatur relasi state change melalui Domain Event Matrix dan membatasi hak akses (Permissions by State).

## Related Domains

- [Business Domain Analysis](./02_Business_Domain_Analysis.md): State Machine berlaku untuk entitas di dalam domain-domain operasional inti.

## Related Processes

- [Business Process Mapping](./03_Business_Process_Mapping.md): Setiap tahapan dalam proses bisnis mensyaratkan status (state) yang valid.

## Related Entities

- Entitas yang dibahas: `Product`, `Purchase Order`, `Receiving`, `Stock Movement`, `Stock Opname`, `Sales Transaction`, `Payment`, `Cash Session`, `Customer`, `Supplier`.
- [Conceptual Data Model](../03_Data/07_Conceptual_Data_Model.md)

## Related Database

- Status (State) dari entitas disimpan sebagai kolom (misal: `status`) di tabel pada [Physical Database Design](../03_Data/09_Physical_Database_Design.md).

## Related API

- API harus memvalidasi transisi state, diatur di [API Contract](../04_API/11_API_Contract.md).

## Business Rules

- Mengikat implementasi fungsional di [Functional Specification](./05_Functional_Spesification.md).

## References

- [Backend Architecture](../02_Architecture/10_Backend_Architecture.md): Aturan-aturan bisnis diimplementasikan pada lapisan Service/Domain dari arsitektur backend.
