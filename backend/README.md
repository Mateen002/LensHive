# 🚀 LensHive Backend - Complete Setup Guide

Django REST API backend for LensHive Flutter application with MySQL database integration.

---

## 📋 Prerequisites

Before starting, make sure you have:

- ✅ **Python 3.8+** installed ([Download from python.org](https://www.python.org/downloads/))
- ✅ **XAMPP** installed (for MySQL database)
- ✅ **Git** (optional, for version control)

---

## 🎯 PHASE 1: Database Setup

### Step 1.1: Start XAMPP
1. Open **XAMPP Control Panel**
2. Click **Start** for both **Apache** and **MySQL**
3. Wait until both show green "Running" status

### Step 1.2: Create Database
1. Open browser and navigate to: `http://localhost/phpmyadmin`
2. Click **"New"** in the left sidebar
3. Enter database name: `lenshive_db`
4. Select Collation: `utf8mb4_unicode_ci`
5. Click **"Create"** button

✅ **Database is now ready!**

---

## 🎯 PHASE 2: Backend Setup

### Step 2.1: Verify Python Installation

Open Command Prompt or PowerShell:

```bash
python --version
```

Should display `Python 3.8` or higher.

### Step 2.2: Navigate to Backend Directory

```bash
cd E:\FYP_developement\LENSHIVE\backend
```

### Step 2.3: Activate Virtual Environment

**Windows PowerShell:**
```bash
venv\Scripts\Activate.ps1
```

**Windows Command Prompt:**
```bash
venv\Scripts\activate.bat
```

You should see `(venv)` at the start of your command prompt.

### Step 2.4: Install Required Packages

```bash
pip install -r requirements.txt
```

**If mysqlclient fails to install**, you have two options:

**Option 1 - Install Visual C++ Build Tools:**
Download and install from: https://visualstudio.microsoft.com/visual-cpp-build-tools/

**Option 2 - Use PyMySQL (Already configured):**
The project is already configured to use PyMySQL as a fallback, so if mysqlclient fails, the app will still work.

---

## 🎯 PHASE 3: Database Migrations

### Step 3.1: Create Migration Files

```bash
python manage.py makemigrations
```

You should see output like:
```
Migrations for 'authentication':
  authentication\migrations\0001_initial.py
    - Create model User
```

### Step 3.2: Apply Migrations to Database

```bash
python manage.py migrate
```

You should see multiple lines ending with `OK`.

### Step 3.3: Create Admin Superuser (OPTIONAL - Currently Disabled)

**Note:** Admin panel is currently disabled. Skip this step for now.

<!-- 
```bash
python manage.py createsuperuser
```

Enter the following when prompted:
- **Email address**: `admin@lenshive.com`
- **Full name**: `Admin User`
- **Password**: Your choice (e.g., `admin123`)
- **Password (again)**: Same password
-->

---

## 🎯 PHASE 4: Start the Server

```bash
python manage.py runserver 8000
```

You should see:
```
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
```

✅ **Backend is now running!**

---

## 🧪 PHASE 5: Test the API

### Test 1: Connection Test

Open browser and visit: `http://localhost:8000/api/auth/test`

Expected response:
```json
{
  "message": "LensHive API is running!",
  "status": "success"
}
```

### Test 2: Admin Panel (Currently Disabled)

**Note:** Admin panel has been disabled for now. You can skip this test.

<!-- 
Visit: `http://localhost:8000/admin`

Login with:
- **Email**: `admin@lenshive.com`
- **Password**: Your superuser password
-->

### Test 3: Using Postman/Thunder Client

**Register a New User:**

- **Method**: `POST`
- **URL**: `http://localhost:8000/api/auth/register`
- **Headers**: `Content-Type: application/json`
- **Body (JSON)**:
```json
{
  "full_name": "Test User",
  "email": "test@example.com",
  "password": "test123456"
}
```

**Expected Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "uuid-here",
    "full_name": "Test User",
    "email": "test@example.com",
    "created_at": "2024-..."
  },
  "token": "your-auth-token-here"
}
```

**Login:**

- **Method**: `POST`
- **URL**: `http://localhost:8000/api/auth/login`
- **Headers**: `Content-Type: application/json`
- **Body (JSON)**:
```json
{
  "email": "test@example.com",
  "password": "test123456"
}
```

**Get Profile (Protected Route):**

- **Method**: `GET`
- **URL**: `http://localhost:8000/api/user/profile`
- **Headers**: 
  - `Content-Type: application/json`
  - `Authorization: Token your-auth-token-here`

---

## 📱 PHASE 6: Connect Flutter App

### Update API Base URL in Flutter

Edit: `lib/services/api_service.dart`

**For Local Development (Flutter Desktop/Web):**
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**For Real Android/iOS Device (same WiFi network):**

1. Find your PC's IP address:
   - Windows: `ipconfig` in Command Prompt
   - Look for "IPv4 Address" under your WiFi adapter
   
2. Use that IP:
```dart
static const String baseUrl = 'http://192.168.x.x:8000/api';
```

### Update User Model to Match Django Response

The Django backend uses `snake_case` for field names. Update your Flutter `User` model if needed:

```dart
// In fromJson method
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id']?.toString() ?? '',
    fullName: json['full_name'] ?? '',  // Note: snake_case from Django
    email: json['email'] ?? '',
    token: json['token'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
  );
}

// In toJson method
Map<String, dynamic> toJson() {
  return {
    'full_name': fullName,  // Send as snake_case to Django
    'email': email,
    'password': password,
  };
}
```

---

## 📚 API Endpoints Reference

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/auth/test` | Test connection | No |
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| POST | `/api/auth/logout` | Logout user | Yes |
| GET | `/api/user/profile` | Get user profile | Yes |

---

## 🔥 Quick Start Commands

### Start Backend Development Server:

```bash
# Terminal 1: Start XAMPP (MySQL must be running)

# Terminal 2: Start Django Backend
cd E:\FYP_developement\LENSHIVE\backend
venv\Scripts\activate
python manage.py runserver 8000
```

### View Database in PHPMyAdmin:

1. Go to: `http://localhost/phpmyadmin`
2. Select database: `lenshive_db`
3. View table: `users`

---

## 🚨 Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| `mysqlclient` won't install | Already handled - PyMySQL is configured as fallback |
| Can't connect to database | Ensure XAMPP MySQL is running on port 3306 |
| Port 8000 already in use | Use different port: `python manage.py runserver 8001` |
| CORS errors | Already configured in settings.py |
| Flutter can't reach API | Check firewall, use correct IP address |
| Import error for decouple | Run: `pip install python-decouple` |

---

## 📁 Project Structure

```
backend/
├── manage.py                    # Django management script
├── requirements.txt             # Python dependencies
├── .env                        # Environment variables (DO NOT COMMIT)
├── .gitignore                  # Git ignore rules
├── README.md                   # This file
│
├── lenshive_backend/           # Main project folder
│   ├── __init__.py
│   ├── settings.py             # Django settings
│   ├── urls.py                 # Main URL configuration
│   ├── wsgi.py                 # WSGI config
│   └── asgi.py                 # ASGI config
│
└── authentication/             # Authentication app
    ├── __init__.py
    ├── models.py               # User model
    ├── serializers.py          # API serializers
    ├── views.py                # API views/endpoints
    ├── urls.py                 # App URL routes
    ├── admin.py                # Admin panel config
    ├── apps.py                 # App configuration
    └── migrations/             # Database migrations
        └── __init__.py
```

---

## 🔐 Security Notes

**For Production:**

1. Change `SECRET_KEY` in `.env` to a strong random value
2. Set `DEBUG=False` in `.env`
3. Update `ALLOWED_HOSTS` in `settings.py`
4. Set `CORS_ALLOW_ALL_ORIGINS = False` and specify allowed origins
5. Use environment-specific database credentials
6. Enable HTTPS
7. Set up proper authentication token expiration

---

## 🎓 Additional Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

---

## 📞 Need Help?

If you encounter any issues:

1. Check that XAMPP MySQL is running
2. Verify virtual environment is activated
3. Ensure all packages are installed: `pip install -r requirements.txt`
4. Check Django logs in the terminal
5. Verify database exists in PHPMyAdmin

---

**Created for LensHive FYP Project** 🎓

