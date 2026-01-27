import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  Future<void> checkAuthStatus() async {
    if (AuthService.isLoggedIn()) {
      _user = AuthService.getCurrentUser();
      if (_user != null) {
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } else {
      _setState(AuthState.unauthenticated);
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading);

    final response = await AuthService.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    if (response.success) {
      _setState(AuthState.unauthenticated);
      return true;
    } else {
      _setState(AuthState.error, error: response.message);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setState(AuthState.loading);

    final response = await AuthService.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    if (response.success && response.data != null) {
      _user = response.data;
      _setState(AuthState.authenticated);
      return true;
    } else {
      _setState(AuthState.error, error: response.message);
      return false;
    }
  }

  Future<void> logout() async {
    _setState(AuthState.loading);
    await AuthService.logout();
    _user = null;
    _setState(AuthState.unauthenticated);
  }

  void _setState(AuthState newState, {String? error}) {
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(
        _user != null ? AuthState.authenticated : AuthState.unauthenticated
      );
    }
  }
}