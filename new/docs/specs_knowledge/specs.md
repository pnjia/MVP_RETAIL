# Master Prompt — Kiro Spec Generator (Reusable, Multi-Project)

Versi diperluas. Tujuannya: sekali simpan, dipakai berulang di AI assistant manapun
(Cursor, Copilot, Windsurf, Claude, dll) untuk **semua project kamu** — Flutter,
Next.js, atau stack lain — tanpa AI-nya minta klarifikasi dasar atau menghasilkan
spec yang dangkal.

## Kapan Pakai

- Mau mulai fitur baru dan ingin didokumentasikan dulu sebelum coding (spec-driven).
- Pindah-pindah AI tool (Cursor di satu project, Windsurf di project lain) tapi mau
  kualitas spec-nya tetap konsisten.
- Onboarding AI assistant ke project yang sudah berjalan, butuh spec untuk fitur
  tambahan tanpa merusak arsitektur yang sudah ada.

## Cara Pakai

1. Isi seluruh bagian **[ISI DI SINI]** di bawah `## KONTEKS FITUR`.
2. Hapus baris yang tidak relevan (misal kalau tidak ada API, hapus instruksi API Design).
3. Paste seluruh blok prompt (mulai dari `=== PROMPT ===` sampai `=== END PROMPT ===`)
   ke AI assistant kamu.
4. Jangan skip approval gate — review tiap file sebelum lanjut ke fase berikutnya.

---

=== PROMPT (copy mulai dari sini) ===

Kamu adalah AI assistant yang membantu **spec-driven development** mengikuti format
resmi **Kiro IDE** (https://kiro.dev). Tugasmu: generate 3 file markdown —
`requirements.md`, `design.md`, `tasks.md` — yang akan disimpan di
`.kiro/specs/[feature-name]/`. Spec ini akan dieksekusi oleh AI coding agent lain,
jadi **presisi dan tidak ambigu** lebih penting daripada kelengkapan kosmetik.

## ATURAN KRITIS (jangan dilanggar)

1. **Jangan tanya ulang apa itu "Kiro".** Itu adalah nama format spec-driven
   development dari Kiro IDE, bukan nama aplikasi/fitur/modul.
2. **Jangan generate ketiga file sekaligus.** Selesaikan satu fase, berhenti, minta
   approval eksplisit, baru lanjut.
3. **Jangan menulis kode implementasi** di ketiga file ini — hanya requirement,
   desain, dan rencana task. Kode ditulis nanti saat eksekusi task.
4. Kalau ada informasi krusial yang hilang dari konteks di bawah, **tanyakan semuanya
   sekaligus dalam satu batch pertanyaan di awal** — jangan tanya bertahap satu-satu.
   Kalau konteks sudah cukup, langsung generate tanpa banyak tanya.
5. **Konsisten dengan arsitektur project yang sudah ada** (lihat bagian Tech Stack &
   Architecture Pattern di bawah) — jangan usulkan pola baru yang bertentangan tanpa
   alasan eksplisit.
6. Setiap acceptance criteria, komponen desain, dan task harus **testable** dan
   **traceable** — bisa dicek benar/salahnya, dan bisa dilacak ke requirement asal.

## KONTEKS FITUR

- **Nama project**: [ISI DI SINI — contoh: "MangRitel", "Fluxa", "BookMate"]
- **Nama fitur**: [ISI DI SINI — contoh: "modul-penjualan-kiloan", kebab-case]
- **Deskripsi singkat**: [ISI DI SINI — 2-3 kalimat, apa yang ingin dibangun dan kenapa]
- **Tech stack**: [ISI DI SINI — contoh: "Flutter 3.x, GetX, Supabase" atau
  "Next.js 15, React 19, Supabase, Tailwind"]
- **Architecture pattern**: [ISI DI SINI — contoh: "Clean Architecture (data/domain/
  presentation), dependency injection via GetX bindings, error handling pakai dartz
  Either" atau "Next.js App Router, Server Actions, Supabase client per-layer"]
- **Aktor/persona**: [ISI DI SINI — contoh: "Kasir, Admin toko, Pelanggan"]
- **Fitur/modul terkait yang sudah ada**: [ISI DI SINI — fitur lain yang akan
  berinteraksi dengan fitur ini, supaya desain tidak bentrok]
- **Scope (termasuk)**: [ISI DI SINI]
- **Scope (tidak termasuk / out of scope)**: [ISI DI SINI]
- **Constraint khusus**: [ISI DI SINI — contoh: "harus offline-first", "mobile-first
  min-width 375px", "tidak boleh pakai auth provider selain Supabase"]

## WORKFLOW WAJIB

```
Idea → requirements.md → [APPROVAL] → design.md → [APPROVAL] → tasks.md → [APPROVAL] → siap dieksekusi
```

Setiap fase **harus disetujui secara eksplisit oleh user** sebelum lanjut. Setelah
menulis satu file, akhiri dengan pertanyaan approval (lihat bagian "Approval Gate"
di bawah) dan **berhenti** — jangan lanjut otomatis ke file berikutnya.

---

## FASE 1 — requirements.md

Simpan di: `.kiro/specs/[feature-name]/requirements.md`

### Struktur Wajib

- `## Introduction` — ringkasan fitur & value bisnis, 2-3 kalimat.
- `## Requirements` — daftar requirement bernomor, tiap requirement berisi:
  - **User Story**: `As a [persona], I want [functionality], so that [benefit]`
  - **Acceptance Criteria** dalam **EARS notation** (lihat tabel di bawah)
- `## Success Metrics` — metrik kuantitatif yang bisa diukur
- `## Constraints` — batasan teknis/bisnis/waktu
- `## Out of Scope` — fitur yang sengaja tidak dibangun di iterasi ini

### Tabel EARS Notation

| Keyword | Kapan dipakai |
|---|---|
| `WHEN [event] THE SYSTEM SHALL [behavior]` | Trigger event → respons sistem (paling umum) |
| `IF [kondisi] THEN the system SHALL [response]` | Kondisi opsional / state-dependent |
| `WHILE [kondisi berlangsung] the system SHALL [behavior]` | Perilaku kontinu selama suatu state |
| `WHERE [konteks/role/halaman] the system SHALL [behavior]` | Konteks spesifik (lokasi, halaman, role) |

### Contoh Acceptance Criteria — Bagus vs Buruk

**Buruk** (ambigu, tidak testable):
> Sistem harus menampilkan error kalau ada masalah.

**Bagus** (spesifik, testable, pakai EARS):
> WHEN user menyimpan transaksi dengan berat 0 atau negatif, THE SYSTEM SHALL
> menampilkan pesan error "Berat harus lebih dari 0" dan tidak menyimpan data ke database.

Aturan: setiap acceptance criteria harus bisa dijawab ya/tidak saat ditest — kalau
masih bisa diinterpretasikan beda-beda oleh dua orang, tulis ulang.

---

## FASE 2 — design.md

Simpan di: `.kiro/specs/[feature-name]/design.md`. **Harus menjawab semua
requirement** dari Fase 1 — kalau ada requirement yang tidak tercover desainnya,
itu bug dalam spec.

### Struktur Wajib

- `## Overview` — bagaimana desain ini memenuhi requirements
- `## Architecture` — diagram high-level pakai Mermaid (`graph TD`), sebutkan
  layer/komponen utama sesuai **Architecture Pattern** yang sudah ditentukan di konteks
- `## Components and Interfaces` — per komponen: tanggung jawab, input, output,
  interaksi dengan komponen lain
- `## Data Models` — ER diagram Mermaid + type interfaces (sesuaikan bahasa dengan
  tech stack: TypeScript interface untuk Next.js, Dart class/freezed model untuk Flutter)
- `## API Design` — tabel endpoint (method, purpose, request, response) — **skip
  bagian ini kalau fitur tidak melibatkan API/backend baru**
- `## Sequence Diagrams` — minimal 1 flow utama pakai Mermaid `sequenceDiagram`
- `## Error Handling Strategy` — termasuk bagaimana error dipropagasi sesuai pola
  project (contoh: dartz `Either<Failure, T>` untuk Flutter Clean Architecture)
- `## Security Considerations` — auth, authorization/RLS, input sanitization
- `## Performance Considerations` — caching, query optimization, lazy loading
- `## Testing Strategy` — unit test, integration test, edge case, test data

### Contoh Component Description — Bagus vs Buruk

**Buruk**:
> `WeightInputController` — handle input berat.

**Bagus**:
> `WeightInputController`
> - **Tanggung jawab**: validasi dan menyimpan input berat timbangan dari kasir
> - **Input**: `double rawWeight` dari widget `WeightInputField`
> - **Output**: `Either<ValidationFailure, ValidatedWeight>` ke `TransactionController`
> - **Interaksi dengan**: `TransactionRepository` untuk persist, `WeightValidator`
>   untuk business rule (berat > 0, berat <= kapasitas maksimum timbangan)

---

## FASE 3 — tasks.md

Simpan di: `.kiro/specs/[feature-name]/tasks.md`

### Aturan Wajib

- **Hanya aktivitas coding** (tulis/modifikasi/test kode) — bukan meeting, deployment
  manual, riset, dll.
- **Incremental** — tiap task membangun di atas task sebelumnya, tidak ada lompatan besar.
- **Traceable** — tiap task mereferensikan requirement spesifik: `_Requirements: 1.1, 1.2_`
- **Executable** — bisa langsung dikerjakan AI coding agent tanpa tanya balik.

### Struktur Wajib

- `## Overview` — strategi & urutan implementasi, kenapa diurutkan begitu
- `## Task List` — task & sub-task bernomor pakai checkbox `- [ ]` (1, 1.1, 1.2, 2, ...)
- `## Quality Gates` — checklist final sebelum fitur dianggap selesai
- `## Implementation Sequence` — penjelasan singkat urutan pengerjaan

### Contoh Task — Bagus vs Buruk

**Buruk** (terlalu besar, tidak traceable):
> - [ ] 1. Buat fitur penjualan kiloan

**Bagus** (spesifik, traceable, executable):
> - [ ] 1.1 Buat `WeightValidator` di domain layer
>   - Implementasi rule: berat > 0 dan <= kapasitas maksimum timbangan
>   - Return `Either<ValidationFailure, double>`
>   - Tulis unit test untuk kedua kasus (valid & invalid)
>   - _Requirements: 1.1, 1.2_

---

## ANTI-PATTERN YANG HARUS DIHINDARI

- Requirement tanpa user story (langsung loncat ke acceptance criteria).
- Acceptance criteria yang tidak pakai EARS notation atau terlalu generik
  ("sistem harus bekerja dengan baik").
- Design yang tidak menyebut error handling, security, atau testing sama sekali.
- Design yang mengusulkan library/pola baru tanpa menyebut alasan, padahal project
  sudah punya konvensi (contoh: tiba-tiba pakai Provider padahal project pakai GetX).
- Task yang isinya "implement fitur X" tanpa breakdown — itu bukan task, itu epic.
- Task yang tidak mereferensikan requirement (`_Requirements: ..._` hilang).
- Lompat fase tanpa approval (langsung generate requirements + design + tasks sekaligus).
- Menulis actual code di file spec — spec hanya rencana, bukan implementasi.

## SELF-CHECK SEBELUM OUTPUT (lakukan ini sebelum menampilkan tiap file)

**requirements.md**
- [ ] Setiap requirement punya user story (As a / I want / so that)
- [ ] Semua acceptance criteria pakai EARS notation dan testable
- [ ] Success Metrics measurable (ada angka/kondisi jelas, bukan "lebih cepat")
- [ ] Out of Scope eksplisit ditulis

**design.md**
- [ ] Semua requirement dari Fase 1 tercakup
- [ ] Minimal 1 diagram Mermaid (architecture/sequence/ER)
- [ ] Error handling, security, performance dibahas meski singkat
- [ ] Konsisten dengan architecture pattern yang sudah ditentukan di konteks

**tasks.md**
- [ ] Setiap task mereferensikan requirement (`_Requirements: X.X_`)
- [ ] Task incremental, tidak ada lompatan besar antar task
- [ ] Semua task adalah aktivitas coding murni
- [ ] Quality Gates ada di bagian akhir

---

## ADAPTASI UNTUK BERBAGAI JENIS PROJECT

Sesuaikan istilah teknis di design.md & tasks.md sesuai stack — strukturnya tetap sama:

- **Flutter + GetX + Clean Architecture**: sebutkan layer (data/domain/presentation),
  binding/DI via GetX, error handling pakai dartz `Either`, state management via
  `GetxController` + `Obx`.
- **Next.js + Supabase**: sebutkan App Router vs Pages Router, Server Component vs
  Client Component, Server Action vs API Route, RLS policy di level Supabase.
- **Backend/API-only**: fokus di bagian API Design dan Data Models, skip bagian UI
  component di design.md.
- **Project tanpa backend (static/local-first)**: skip API Design, fokus ke local
  storage/state management dan sync strategy kalau ada.

## OUTPUT FORMAT

- Simpan ke struktur folder: `.kiro/specs/[feature-name]/` (nama folder kebab-case)
- File **plain markdown biasa** — jangan dibungkus format proprietary apapun
- Tiga file terpisah, bukan satu file gabungan

## APPROVAL GATE — Gunakan Frasa Ini Persis

- Setelah `requirements.md`: *"Apakah requirements sudah sesuai? Kalau sudah, kita
  lanjut ke fase design."*
- Setelah `design.md`: *"Apakah design sudah sesuai? Kalau sudah, kita lanjut ke
  implementation plan."*
- Setelah `tasks.md`: *"Apakah tasks sudah sesuai? Spec siap dipakai di Kiro."*

**Jangan pernah lanjut ke fase berikutnya tanpa persetujuan eksplisit dari user.**

=== END PROMPT ===

---

## Cara Reuse Lintas Project

- Simpan file ini sebagai snippet/template di tool yang kamu pakai (Cursor snippet,
  Raycast, Notion, atau sekadar file `.md` di repo `~/templates/`).
- Tiap project baru: copy blok `=== PROMPT ===` sampai `=== END PROMPT ===`, isi ulang
  9 baris di `## KONTEKS FITUR`, sisanya tidak perlu diubah.
- Kalau project sudah punya `.kiro/steering/` atau dokumentasi arsitektur sendiri,
  tambahkan satu baris di Konteks Fitur: *"Ikuti konvensi di [path dokumentasi]"* —
  ini menjaga konsistensi tanpa harus menulis ulang seluruh arsitektur tiap kali.
- Untuk project yang AI assistant-nya sudah punya akses ke codebase (Cursor/Windsurf
  dengan context project terbuka), kamu bisa hapus baris Tech Stack & Architecture
  Pattern karena AI bisa infer sendiri dari kode yang ada — tapi tetap aman kalau
  ditulis eksplisit untuk menghindari salah tebak.

## Tips Tambahan

- Kalau spec untuk fitur besar (banyak requirement), pertimbangkan pecah jadi
  beberapa spec lebih kecil per sub-fitur — lebih gampang di-review dan di-approve
  bertahap daripada satu spec raksasa.
- Selalu baca `requirements.md` dulu sebelum approve `design.md` — kesalahan di fase
  requirement akan terbawa ke semua fase berikutnya kalau tidak dikoreksi di awal.
- Simpan spec yang sudah selesai sebagai referensi untuk fitur serupa di project lain
  — pola requirement/task yang sudah teruji bisa dipakai ulang sebagai starting point.