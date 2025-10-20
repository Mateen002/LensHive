# 🎯 LensHive - Flutter Authentication App

A modern Flutter app with **Riverpod state management**, **Remember Me** functionality, and **Django REST API** backend.

---

## ✨ Features

- ✅ **User Authentication** - Login & Registration
- ✅ **Riverpod State Management** - Global state handling
- ✅ **Remember Me** - Auto-login on app restart
- ✅ **Local Persistence** - SharedPreferences storage
- ✅ **Django Backend** - RESTful API ready
- ✅ **Responsive UI** - Works on all screen sizes
- ✅ **Modern Design** - Clean and intuitive interface

---

## 📦 Tech Stack

### Frontend (Flutter)
- **Flutter** 3.7.2+
- **Riverpod** 2.6.1 - State management
- **SharedPreferences** 2.2.2 - Local storage
- **HTTP** 1.1.0 - API requests
- **ScreenUtil** 5.9.3 - Responsive design

### Backend (Django)
- **Django** 4.2+
- **Django REST Framework** - API
- **Simple JWT** - Token authentication
- **CORS Headers** - Cross-origin support

---

## 🚀 Quick Start

### 1. Clone & Install

```bash
git clone <your-repo-url>
cd lenshive
flutter pub get
```

### 2. Run Flutter App

```bash
flutter run
```

### 3. Setup Django Backend

See **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for complete Django setup.

---

## 📱 App Flow

```
Splash Screen (2s)
       ↓
┌──────┴──────┐
│             │
Has Saved     No Saved
User?         User?
│             │
↓             ↓
Home          Login
Screen        Screen
              ↓
          Registration
```

---

## 🏗️ Project Structure

```
lib/
├── models/
│   ├── user_model.dart        # User data model
│   └── auth_state.dart        # Auth state model
├── providers/
│   └── auth_provider.dart     # Riverpod auth provider
├── services/
│   ├── api_service.dart       # HTTP API service
│   └── storage_service.dart   # Local storage
├── screens/
│   ├── splash_screen.dart     # Splash with auto-login
│   ├── login_screen.dart      # Login with Remember Me
│   ├── registration_screen.dart
│   └── home_screen.dart       # User profile
└── main.dart                  # App entry
```

---

## 🔑 Key Features Explained

### Remember Me
- Check "Remember Me" on login
- User data saved locally
- Auto-login on next app start
- Pre-fills email for convenience

### Riverpod State Management
```dart
// Access auth state anywhere
final isAuth = ref.watch(isAuthenticatedProvider);
final user = ref.watch(currentUserProvider);

// Perform auth actions
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.login(...);
```

### Local Persistence
- User data stored with SharedPreferences
- Token management
- Remember Me preferences
- Saved email feature

---

## 🔧 Configuration

### API Base URL

**File:** `lib/services/api_service.dart` (line 15)

```dart
// Change based on your environment:
static const String baseUrl = 'http://10.0.2.2:8000/api';  // Android Emulator
// static const String baseUrl = 'http://localhost:8000/api';  // iOS
// static const String baseUrl = 'http://YOUR_IP:8000/api';  // Physical Device
// static const String baseUrl = 'https://yourdomain.com/api';  // Production
```

---

## 📚 Documentation

| File | Description |
|------|-------------|
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)** | Complete Django backend setup |
| **[API_REFERENCE.md](API_REFERENCE.md)** | API endpoints documentation |

---

## 🧪 Testing

### Test Login Flow
1. Open app → Splash (2s) → Login screen
2. Enter credentials + check "Remember Me"
3. Login → Home screen
4. Close app completely
5. Reopen → Auto-login to Home! ✨

### Test Registration
1. Click "Register" on login screen
2. Fill all fields (full name, email, password)
3. Submit → Returns to login
4. Login with new credentials

---

## 🔒 Security

- ✅ **JWT Token Authentication** - Secure token-based auth
- ✅ **Password Hashing** - Django PBKDF2
- ✅ **HTTPS Ready** - SSL/TLS support
- ✅ **Token Validation** - Auto-check on startup
- ✅ **Session Management** - Proper logout flow

---

## 📖 API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/auth/register/` | Register user |
| POST | `/api/auth/login/` | Login user |
| POST | `/api/auth/logout/` | Logout user |
| GET | `/api/auth/profile/` | Get user profile |
| GET | `/api/status/` | API health check |

See **[API_REFERENCE.md](API_REFERENCE.md)** for detailed documentation.

---

## 🐛 Troubleshooting

### App stuck on splash screen?
- Check if Django backend is running
- Verify API URL in `api_service.dart`
- Check console for errors

### Remember Me not working?
```dart
// Debug storage
final hasData = await StorageService.hasUserData();
print('Has saved user: $hasData');
```

### Django connection fails?
```bash
# Verify Django is running
python manage.py runserver

# Check CORS settings in Django
CORS_ALLOW_ALL_ORIGINS = True  # Development only
```

---

## 🚀 Deployment

### Flutter App
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Django Backend
See **[SETUP_GUIDE.md](SETUP_GUIDE.md)** → Deployment section

---

## 📝 License

[Your License Here]

---

## 👨‍💻 Author

[Your Name]

---

## 🙏 Acknowledgments

- Flutter Team
- Riverpod by Remi Rousselet
- Django REST Framework

---

**Need Help?** Check the documentation files or open an issue!

**Happy Coding! 🎉**
primary color : Color(0xFF0A83BC)