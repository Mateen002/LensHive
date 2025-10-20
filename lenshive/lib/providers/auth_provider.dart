import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Authentication State
/// Holds the current authentication state of the app
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  /// Create a copy of AuthState with updated fields
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Authentication State Notifier
/// Manages authentication state and provides methods for login, register, and logout
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    // Check if user is already logged in when app starts
    _checkLoginStatus();
  }

  /// Check if user is logged in on app start
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await StorageService.isLoggedIn();
    if (isLoggedIn) {
      final user = await StorageService.getUser();
      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
        );
      }
    }
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Call API service to login
      final user = await ApiService.login(
        email: email,
        password: password,
      );

      // Save user data to local storage
      await StorageService.saveUser(user);

      // Save email if remember me is enabled
      if (rememberMe) {
        await StorageService.saveEmail(email);
      } else {
        await StorageService.clearSavedEmail();
      }

      // Update state with user data
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
      );

      return true;
    } catch (e) {
      // Handle login error
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Call API service to register
      final user = await ApiService.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      // Save user data to local storage
      await StorageService.saveUser(user);

      // Update state with user data
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
      );

      return true;
    } catch (e) {
      // Handle registration error
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    // Clear user data from local storage
    await StorageService.clearUserData();

    // Reset state
    state = AuthState();
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    if (state.user?.token != null) {
      try {
        final user = await ApiService.getProfile(state.user!.token!);
        state = state.copyWith(user: user);
        await StorageService.saveUser(user);
      } catch (e) {
        // Handle error silently or show notification
        print('Error refreshing user: $e');
      }
    }
  }
}

/// Auth Provider
/// Provides access to AuthNotifier and AuthState
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Convenience providers for specific auth state properties
/// These providers allow widgets to watch specific parts of the auth state

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Provider for loading state
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

/// Provider for error message
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).errorMessage;
});

/// Provider for authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

