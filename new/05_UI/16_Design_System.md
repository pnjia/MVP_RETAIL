---
id: ui-design-system
title: Design System
type: ui
parent: ui-screen-spec
tags: ui, design system
version: 1.0
---

# Tahap 16.1 — UX Principle

Menurut saya ini harus ditulis dulu.

Misalnya.

## 1. Speed First

Kasir tidak boleh lebih dari

```
3 tap

untuk transaksi normal
```

---

## 2. Information First

Yang paling penting selalu muncul.

Contoh Product.

```
Nama

Harga

Stok

SKU
```

Bukan

```
Deskripsi panjang

Tag

Metadata
```

---

## 3. Large Touch Area

Button

minimal

```
44x44
```

agar nyaman digunakan di tablet.

---

## 4. Keyboard Friendly

Desktop POS

harus bisa dipakai tanpa mouse.

Misalnya

```
F2

↓

Cari Produk

F4

↓

Bayar

ESC

↓

Batal

CTRL + P

↓

Print
```

Hal seperti ini hampir tidak pernah dibuat AI.

---

## 5. Scan Friendly

Barcode Scanner

↓

langsung fokus ke field.

Tidak perlu klik textbox.

---

# Tahap 16.2 — Visual Language

Di sinilah identitas produk dibuat.

Bukan

```
Blue

Purple

Gradient
```

Tetapi menentukan karakter.

Contoh.

```
Industrial

Professional

Dense

Fast

Minimal Distraction
```

atau

```
Modern Retail

Friendly

Clean

Simple
```

Ini menentukan seluruh desain.

---

# Tahap 16.3 — Information Density

Ini sangat penting untuk POS.

Saya justru menyarankan.

```
High Density
```

karena kasir ingin melihat banyak data.

Misalnya tabel.

AI biasanya membuat.

```
10 row
```

Saya lebih suka

```
25–50 row
```

per halaman.

---

# Tahap 16.4 — Layout System

Saya tidak suka

```
Container

↓

1280px
```

Seperti dashboard SaaS.

Saya lebih suka.

```
Sidebar

+

Workspace

+

Inspector

+

Bottom Panel
```

Seperti software profesional.

Contoh:

```
VS Code

Photoshop

Excel

Figma
```

Karena POS adalah aplikasi kerja.

---

# Tahap 16.5 — Component System

Saya tidak ingin membuat

```
Button

Input

Card
```

Saya ingin membuat

```
Business Component
```

Misalnya.

```
Product Card

Cart Panel

Payment Summary

Cash Drawer

Receipt Preview

Stock Badge

Price Badge

Purchase Timeline

Inventory Timeline
```

Ini jauh lebih bernilai.

---

# Tahap 16.6 — Design Token

Baru sekarang.

Tetapi token dibuat berdasarkan UX.

Misalnya.

Spacing.

Bukan

```
4

8

16

32
```

Tetapi.

```
Compact

Normal

Comfortable
```

Karena POS membutuhkan density berbeda.

---

Typography.

Bukan.

```
H1

H2

Body
```

Tetapi.

```
Receipt

Table

Form

Dashboard KPI

Dialog

Toolbar
```

---

# Color

Saya bahkan tidak ingin menentukan

```
Primary Blue
```

di awal.

Saya ingin menentukan semantic.

```
Success

Danger

Warning

Information

Neutral

Inventory

Finance

Sales
```

Nanti baru dipilih warnanya.

---

# Icon

Saya juga tidak ingin.

```
Box

Dollar

User
```

Saya ingin.

```
Stock Adjustment

Receiving

Purchase

Cash Session

Stock Opname
```

Icon berdasarkan domain.

---

# Motion

Tidak banyak animasi.

Saya ingin.

```
Instant

100 ms

150 ms
```

Bukan

```
400 ms

fade

scale

bounce
```

Karena POS harus cepat.

---

## Summary

This document defines the Design System and UX principles for the MVP Retail application, focusing on speed, information density, keyboard friendliness, and domain-specific semantic design.

## Related Domains

- [Business Domain Analysis](../01_Business/02_Business_Domain_Analysis.md) (influences the semantic colors and domain-specific icons)

## Related Processes

- N/A

## Related Entities

- N/A

## Related Database

- N/A

## Related API

- N/A

## Business Rules

- [Functional Specification](../01_Business/05_Functional_Spesification.md) (requirements for fast data entry and keyboard shortcuts in POS)

## References

- [Frontend Architecture](../02_Architecture/12_Frontend_Architecture.md)
- [Screen Specification](./15_Screen_Spesification.md)
