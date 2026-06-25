# 05 — API Publik

**Tahap:** Enterprise · **Domain:** System / Integration

## Tujuan
Membuka API resmi agar pihak ketiga / aplikasi lain (mobile, marketplace connector, akuntansi eksternal) bisa mengakses data & operasi sistem secara aman dan terkontrol.

## Ruang Lingkup
- REST API publik berversi (`/api/v1`)
- Autentikasi API key / OAuth2
- Rate limiting & kuota
- Webhook keluar (event: order.created, stock.low)
- Dokumentasi (OpenAPI/Swagger)

## Data Model

**api_clients**
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | PK | |
| name | varchar | nama aplikasi |
| client_id / client_secret(hash) | varchar | |
| scopes | json | izin akses (`products:read`,`orders:write`) |
| rate_limit | int | req/menit |
| is_active | boolean | |

**api_request_logs**: `client_id`, `endpoint`, `status`, `ip`, `created_at`.
**webhooks**: `client_id`, `event`, `target_url`, `secret`, `is_active`.

## Alur Kerja
1. Admin daftarkan klien → terbit `client_id` + `secret` + scope.
2. Klien autentikasi (OAuth2 client credentials / API key) → dapat token.
3. Setiap request dicek: token valid, scope cukup, di bawah rate limit.
4. Event internal memicu webhook keluar ke `target_url` (ditandatangani).

## Aturan Bisnis
- Versi API stabil; perubahan breaking lewat versi baru (`v2`), `v1` tetap didukung selama masa transisi.
- Scope membatasi akses (least privilege). Secret disimpan ter-hash.
- Rate limiting & logging wajib untuk cegah penyalahgunaan.
- Webhook ditandatangani (HMAC) & retry dengan backoff bila gagal.

## Acceptance Criteria
- [ ] Klien terdaftar bisa akses endpoint sesuai scope.
- [ ] Rate limit & logging aktif.
- [ ] Webhook terkirim, ditandatangani, dan retry saat gagal.
- [ ] Dokumentasi OpenAPI tersedia.

## Dependensi
- `Tahap 2.0/03_User_Management` (scope/permission). Dipakai `06_Marketplace_Integration`.
