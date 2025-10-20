# 🛠️ LensHive Setup Guide

Complete guide to set up Django backend and Flutter app.

---

## 📋 Prerequisites

- **Python 3.8+** and pip
- **Flutter 3.7.2+**
- **Git**
- **Code Editor** (VS Code recommended)

---

## 🚀 Part 1: Django Backend Setup

### Step 1: Create Django Project

```bash
# Create project folder
mkdir lenshive_backend
cd lenshive_backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install packages
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers python-decouple
```

### Step 2: Create Django Apps

```bash
# Create project
django-admin startproject lenshive_api .

# Create authentication app
python manage.py startapp authentication

# Create API app
python manage.py startapp api
```

### Step 3: Configure Settings

**File:** `lenshive_api/settings.py`

```python
from pathlib import Path
from datetime import timedelta
from decouple import config

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = config('SECRET_KEY', default='your-secret-key-change-in-production')
DEBUG = config('DEBUG', default=True, cast=bool)
ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third party
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    
    # Local apps
    'authentication',
    'api',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',  # Before CommonMiddleware
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'lenshive_api.urls'

# Database (SQLite for development)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Custom User Model
AUTH_USER_MODEL = 'authentication.User'

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}

# JWT Settings
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=7),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=30),
    'ROTATE_REFRESH_TOKENS': True,
}

# CORS (allow all for development)
CORS_ALLOW_ALL_ORIGINS = True

STATIC_URL = 'static/'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
```

### Step 4: Create User Model

**File:** `authentication/models.py`

```python
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    full_name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'full_name']
    
    def __str__(self):
        return self.email
```

### Step 5: Create Serializers

**File:** `authentication/serializers.py`

```python
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password

User = get_user_model()

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        required=True,
        validators=[validate_password]
    )
    
    class Meta:
        model = User
        fields = ('id', 'full_name', 'email', 'password')
    
    def create(self, validated_data):
        username = validated_data['email'].split('@')[0]
        user = User.objects.create_user(
            username=username,
            email=validated_data['email'],
            full_name=validated_data['full_name'],
            password=validated_data['password']
        )
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'full_name', 'email', 'last_login')
```

### Step 6: Create Views

**File:** `authentication/views.py`

```python
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate, get_user_model
from .serializers import UserRegistrationSerializer

User = get_user_model()

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    serializer = UserRegistrationSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        return Response({
            'success': True,
            'message': 'Registration successful',
            'data': {
                'user_id': user.id,
                'full_name': user.full_name,
                'email': user.email,
            }
        }, status=status.HTTP_201_CREATED)
    
    errors = serializer.errors
    error_message = next(iter(errors.values()))[0] if errors else 'Registration failed'
    return Response({'success': False, 'message': str(error_message)}, status=400)

@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'success': False, 'message': 'Invalid email or password'}, status=401)
    
    user = authenticate(username=user.username, password=password)
    
    if user:
        refresh = RefreshToken.for_user(user)
        return Response({
            'success': True,
            'message': 'Login successful',
            'data': {
                'user_id': user.id,
                'full_name': user.full_name,
                'email': user.email,
                'token': str(refresh.access_token),
                'last_login': user.last_login,
            }
        })
    
    return Response({'success': False, 'message': 'Invalid email or password'}, status=401)
```

### Step 7: Configure URLs

**File:** `authentication/urls.py` (create new)

```python
from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register),
    path('login/', views.login),
]
```

**File:** `api/views.py`

```python
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from django.db import connection

@api_view(['GET'])
@permission_classes([AllowAny])
def api_status(request):
    try:
        connection.ensure_connection()
        db_status = 'connected'
    except:
        db_status = 'disconnected'
    
    return Response({
        'api_name': 'LensHive API',
        'version': '1.0.0',
        'status': 'active',
        'database_status': db_status,
    })
```

**File:** `lenshive_api/urls.py`

```python
from django.contrib import admin
from django.urls import path, include
from api.views import api_status

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/status/', api_status),
    path('api/auth/', include('authentication.urls')),
]
```

### Step 8: Run Migrations

```bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser  # Optional
```

### Step 9: Start Django Server

```bash
python manage.py runserver
```

**Server:** http://127.0.0.1:8000/

---

## 📱 Part 2: Flutter App Setup

### Step 1: Install Dependencies

```bash
cd lenshive
flutter pub get
```

### Step 2: Configure API URL

**File:** `lib/services/api_service.dart` (line 15)

```dart
// Choose based on platform:
static const String baseUrl = 'http://10.0.2.2:8000/api';  // Android Emulator
// static const String baseUrl = 'http://localhost:8000/api';  // iOS Simulator
// static const String baseUrl = 'http://YOUR_IP:8000/api';  // Physical Device
```

To find your IP:
```bash
# Windows
ipconfig

# macOS/Linux
ifconfig
```

### Step 3: Run Flutter App

```bash
flutter run
```

---

## ✅ Verify Setup

### Test API (Browser/Postman)

**Status Check:**
```
GET http://127.0.0.1:8000/api/status/
```

**Register:**
```
POST http://127.0.0.1:8000/api/auth/register/
Content-Type: application/json

{
  "full_name": "Test User",
  "email": "test@example.com",
  "password": "Test@1234"
}
```

**Login:**
```
POST http://127.0.0.1:8000/api/auth/login/
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "Test@1234"
}
```

### Test Flutter App

1. Open app → Splash (2s) → Login
2. Click "Register" → Fill form → Submit
3. Login with credentials + "Remember Me"
4. See Home screen with profile
5. Close app → Reopen → Auto-login! ✨

---

## 🚀 Deployment

### Django to Heroku

```bash
# Install Heroku CLI
pip install gunicorn
echo "web: gunicorn lenshive_api.wsgi" > Procfile
pip freeze > requirements.txt

# Deploy
heroku create lenshive-api
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
heroku run python manage.py migrate
```

### Flutter App

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🔒 Production Checklist

- [ ] Change SECRET_KEY
- [ ] Set DEBUG = False
- [ ] Update ALLOWED_HOSTS
- [ ] Use PostgreSQL/MySQL
- [ ] Configure CORS for specific domain
- [ ] Enable HTTPS
- [ ] Set up environment variables
- [ ] Add rate limiting
- [ ] Enable logging

---

## 🐛 Troubleshooting

**Django won't start:**
```bash
# Check port
python manage.py runserver 8080
```

**Flutter can't connect:**
- Verify Django is running
- Check API URL matches your setup
- For physical devices, use computer's IP

**CORS errors:**
```python
# In settings.py
CORS_ALLOW_ALL_ORIGINS = True  # Development only
```

---

## 📚 Additional Resources

- [Django Docs](https://docs.djangoproject.com/)
- [DRF Docs](https://www.django-rest-framework.org/)
- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod Docs](https://riverpod.dev/)

---

**Setup Complete! 🎉** Your LensHive app is ready to use!

