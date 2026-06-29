# Cloud Desktop A

GitHub Codespace — Desktop A (Account 1).
noVNC + Google Chrome + Openbox on port 6080.
API on port 8080.

## Setup

1. Fork / push this repo to GitHub Account A
2. Create a Codespace (Code → Codespaces → New)
3. Codespace auto-starts desktop on ports 6080 & 8080
4. Set secrets in Codespace settings:
   - `VNC_PASSWORD` (default: V1312)
   - `DATABASE_URL` (Supabase Session Pooler URL)
   - `IDLE_TIMEOUT` (default: 300 = 5min)

## Access

- noVNC: `https://CODESPACE_NAME-6080.preview.app.github.dev/vnc.html`
- API:   `https://CODESPACE_NAME-8080.preview.app.github.dev/api/health`
