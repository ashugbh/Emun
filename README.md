# Emun Flutter App

Flutter frontend for Emun marketplace.

## Backend Location
- Backend is now separated from the Flutter app and lives at:
  - `C:\Users\esh\Documents\Flutter projects\emun_backend`

## Run Backend
```bash
cd "C:\Users\esh\Documents\Flutter projects\emun_backend"
python manage.py migrate
python manage.py seed_emun_data
python manage.py runserver
```

## Run Flutter App
```bash
cd "C:\Users\esh\Documents\Flutter projects\Emun"
flutter run
```

## API Base URL
- Default:
  - Android emulator: `http://10.0.2.2:8000/api/v1`
  - iOS simulator / desktop: `http://127.0.0.1:8000/api/v1`
- Override manually:
```bash
flutter run --dart-define=EMUN_API_BASE_URL=http://<your-ip>:8000/api/v1
```
