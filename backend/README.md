# Doctor Mitra Internet API

This is the shared backend for the single Doctor Mitra app.

It stores one connected state used by:
- Patient Panel
- Doctor Panel
- Admin Panel

## Run Locally

```bash
cd backend
npm start
```

API URL:

```text
http://localhost:8080
```

Health check:

```text
GET /health
```

State API:

```text
GET /api/state
PUT /api/state
POST /api/reset
```

## Build APK With Internet API

Use your deployed backend URL:

```bash
flutter build apk --release --dart-define=DOCTOR_MITRA_API_URL=https://your-api-domain.com
```

Without `DOCTOR_MITRA_API_URL`, the app runs in local demo mode.
With `DOCTOR_MITRA_API_URL`, the app syncs patient, doctor and admin data through the internet API.
