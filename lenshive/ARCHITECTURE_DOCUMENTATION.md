# 🏗️ LensHive - MVVM Architecture Documentation

## 📋 Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [MVVM Components](#mvvm-components)
4. [Widget Documentation](#widget-documentation)
5. [Usage Examples](#usage-examples)

---

## 🏛️ Architecture Overview

LensHive follows **MVVM (Model-View-ViewModel)** pattern with **Riverpod** for state management.

```
┌─────────────────────────────────────────────────┐
│                    VIEW                          │
│  (UI Widgets - Screens, Components)             │
└─────────────────┬───────────────────────────────┘
                  │
                  │ ref.watch/ref.read
                  │
┌─────────────────▼───────────────────────────────┐
│                 VIEWMODEL                       │
│  (Business Logic - Riverpod Providers)          │
└─────────────────┬───────────────────────────────┘
                  │
                  │ Uses Services
                  │
┌─────────────────▼───────────────────────────────┐
│                  MODEL                          │
│  (Data Models, Services, Repositories)          │
└─────────────────────────────────────────────────┘
```

### Benefits of MVVM:
- ✅ **Separation of Concerns** - UI, Logic, and Data are separate
- ✅ **Testability** - Easy to unit test ViewModels
- ✅ **Reusability** - ViewModels can be used across multiple Views
- ✅ **Maintainability** - Clear structure makes code easy to maintain
- ✅ **Scalability** - Easy to add new features

---

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   │   ├── app_colors.dart         # Color definitions
│   │   ├── app_strings.dart        # String constants
│   │   ├── app_sizes.dart          # Size constants
│   │   └── api_constants.dart      # API endpoints
│   ├── theme/                      # App theming
│   │   ├── app_theme.dart          # Theme configuration
│   │   └── text_styles.dart        # Text style definitions
│   ├── utils/                      # Utility functions
│   │   ├── validators.dart         # Input validation
│   │   ├── helpers.dart            # Helper functions
│   │   └── extensions.dart         # Dart extensions
│   └── errors/                     # Error handling
│       ├── exceptions.dart         # Custom exceptions
│       └── failures.dart           # Failure classes
│
├── data/                           # Data layer
│   ├── models/                     # Data models
│   │   ├── user_model.dart         # User data model
│   │   ├── auth_state.dart         # Auth state model
│   │   └── api_response.dart       # API response model
│   ├── repositories/               # Data repositories
│   │   ├── auth_repository.dart    # Authentication repository
│   │   └── storage_repository.dart # Local storage repository
│   ├── datasources/                # Data sources
│   │   ├── remote/                 # Remote data sources
│   │   │   └── auth_remote_datasource.dart
│   │   └── local/                  # Local data sources
│   │       └── auth_local_datasource.dart
│   └── services/                   # External services
│       ├── api_service.dart        # HTTP API service
│       └── storage_service.dart   # Local storage service
│
├── presentation/                   # Presentation layer
│   ├── viewmodels/                 # ViewModels (Business Logic)
│   │   ├── auth_viewmodel.dart     # Authentication ViewModel
│   │   └── splash_viewmodel.dart   # Splash ViewModel
│   ├── views/                      # Views (Screens)
│   │   ├── splash/                 # Splash screen
│   │   │   ├── splash_view.dart    # Splash UI
│   │   │   └── splash_widgets.dart # Splash widgets
│   │   ├── auth/                   # Authentication screens
│   │   │   ├── login/              # Login screen
│   │   │   │   ├── login_view.dart
│   │   │   │   └── login_widgets.dart
│   │   │   └── register/           # Registration screen
│   │   │       ├── register_view.dart
│   │   │       └── register_widgets.dart
│   │   └── home/                   # Home screen
│   │       ├── home_view.dart
│   │       └── home_widgets.dart
│   ├── widgets/                    # Reusable widgets
│   │   ├── common/                 # Common widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_app_bar.dart
│   │   │   └── loading_widget.dart
│   │   └── auth/                   # Auth-specific widgets
│   │       ├── password_field.dart
│   │       └── remember_me_checkbox.dart
│   └── providers/                  # Riverpod providers
│       ├── auth_provider.dart      # Auth state provider
│       └── theme_provider.dart     # Theme provider
│
└── main.dart                       # App entry point
```

---

## 🔧 MVVM Components

### 1. **Model** (Data Layer)
- **Purpose**: Represents data and business rules
- **Contains**: Data models, repositories, data sources
- **Example**: `UserModel`, `AuthRepository`

### 2. **View** (Presentation Layer)
- **Purpose**: UI components that users interact with
- **Contains**: Screens, widgets, UI logic
- **Example**: `LoginView`, `CustomButton`

### 3. **ViewModel** (Business Logic Layer)
- **Purpose**: Connects View and Model, handles business logic
- **Contains**: Riverpod providers, state management
- **Example**: `AuthViewModel`, `SplashViewModel`

---

## 🎨 Widget Documentation

### Core Widgets

#### **CustomButton**
Reusable button widget with different styles.

```dart
CustomButton(
  text: 'Login',
  onPressed: () => viewModel.login(),
  isLoading: viewModel.isLoading,
  style: ButtonStyle.primary,
)
```

#### **CustomTextField**
Reusable text input field with validation.

```dart
CustomTextField(
  controller: emailController,
  label: 'Email',
  validator: Validators.email,
  keyboardType: TextInputType.emailAddress,
)
```

#### **PasswordField**
Specialized password field with visibility toggle.

```dart
PasswordField(
  controller: passwordController,
  label: 'Password',
  validator: Validators.password,
)
```

#### **LoadingWidget**
Shows loading indicator with optional message.

```dart
LoadingWidget(
  message: 'Logging in...',
  size: LoadingSize.medium,
)
```

---

## 📖 Usage Examples

### ViewModel Usage

```dart
// In a View (Screen)
class LoginView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    
    return Scaffold(
      body: authViewModel.isLoading
        ? LoadingWidget(message: 'Logging in...')
        : LoginForm(),
    );
  }
}
```

### Repository Usage

```dart
// In a ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  
  AuthViewModel(this._authRepository) : super(AuthState.initial());
  
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _authRepository.login(email, password);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      ),
    );
  }
}
```

---

## 🎯 Key Benefits

### 1. **Clear Separation**
- **View**: Only handles UI and user interactions
- **ViewModel**: Contains business logic and state
- **Model**: Manages data and repositories

### 2. **Testability**
```dart
// Easy to test ViewModels
test('should login user successfully', () async {
  // Arrange
  when(mockAuthRepository.login(any, any))
    .thenAnswer((_) async => Right(mockUser));
  
  // Act
  await authViewModel.login('test@example.com', 'password');
  
  // Assert
  expect(authViewModel.state.isAuthenticated, true);
});
```

### 3. **Reusability**
- ViewModels can be used across multiple Views
- Widgets are reusable across screens
- Models can be shared between features

### 4. **Maintainability**
- Easy to find and modify specific functionality
- Clear structure makes onboarding easier
- Consistent patterns across the app

---

## 🚀 Getting Started

1. **Create a new feature**:
   - Add model in `data/models/`
   - Create repository in `data/repositories/`
   - Implement ViewModel in `presentation/viewmodels/`
   - Build View in `presentation/views/`

2. **Use existing widgets**:
   - Import from `presentation/widgets/`
   - Follow the documentation for each widget

3. **Follow the patterns**:
   - Use Riverpod for state management
   - Keep Views simple and focused on UI
   - Put business logic in ViewModels
   - Use repositories for data access

---

**This architecture ensures your LensHive app is scalable, maintainable, and easy to understand! 🎉**

