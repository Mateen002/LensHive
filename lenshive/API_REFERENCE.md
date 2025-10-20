# 📡 LensHive API Reference

Quick reference for all API endpoints.

---

## Base URL

```
Development: http://127.0.0.1:8000/api
Production:  https://yourdomain.com/api
```

---

## 🔓 Public Endpoints (No Auth Required)

### 1. API Status

**GET** `/status/`

Check API health and database connection.

**Response:**
```json
{
  "api_name": "LensHive API",
  "version": "1.0.0",
  "status": "active",
  "database_status": "connected"
}
```

---

### 2. User Registration

**POST** `/auth/register/`

Create a new user account.

**Request:**
```json
{
  "full_name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePass123"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user_id": 1,
    "full_name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Email already registered"
}
```

---

### 3. User Login

**POST** `/auth/login/`

Authenticate user and get token.

**Request:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user_id": 1,
    "full_name": "John Doe",
    "email": "john@example.com",
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "last_login": "2025-10-13T10:30:00Z"
  }
}
```

**Error Responses:**
```json
// 401 - Invalid credentials
{
  "success": false,
  "message": "Invalid email or password"
}

// 403 - Account disabled
{
  "success": false,
  "message": "Account is disabled"
}
```

---

## 🔒 Protected Endpoints (Auth Required)

Include token in header:
```
Authorization: Bearer YOUR_TOKEN_HERE
```

### 4. User Profile

**GET** `/auth/profile/`

Get current user profile.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "full_name": "John Doe",
    "email": "john@example.com",
    "last_login": "2025-10-13T10:30:00Z"
  }
}
```

---

### 5. Logout

**POST** `/auth/logout/`

Invalidate user token.

**Request:**
```json
{
  "refresh_token": "your_refresh_token"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Logout successful"
}
```

---

## 🧪 Testing with cURL

### Register
```bash
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Test User",
    "email": "test@example.com",
    "password": "Test@1234"
  }'
```

### Login
```bash
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test@1234"
  }'
```

### Profile (with token)
```bash
curl -X GET http://127.0.0.1:8000/api/auth/profile/ \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🔧 Flutter Integration

### Using ApiService

```dart
import 'package:lenshive/services/api_service.dart';

// Register
final response = await ApiService.register(
  fullName: 'John Doe',
  email: 'john@example.com',
  password: 'SecurePass123',
);

if (response['success']) {
  print('Registration successful!');
}

// Login
final loginResponse = await ApiService.login(
  email: 'john@example.com',
  password: 'SecurePass123',
);

if (loginResponse['success']) {
  final token = loginResponse['data']['token'];
  // Save token
}
```

---

## 📊 Response Format

All endpoints return:

```typescript
{
  success: boolean,      // Operation status
  message?: string,      // Response message
  data?: object          // Response data (if applicable)
}
```

---

## ⚠️ Error Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

---

## 🔐 Security

- Passwords are hashed with Django's PBKDF2
- JWT tokens expire after 7 days
- Refresh tokens expire after 30 days
- HTTPS required in production
- Rate limiting recommended

---

## 📝 Validation Rules

### Registration
- `full_name`: Min 3 characters
- `email`: Valid email format, unique
- `password`: Min 6 characters

### Login
- `email`: Required, valid format
- `password`: Required

---

**For detailed setup, see [SETUP_GUIDE.md](SETUP_GUIDE.md)**

