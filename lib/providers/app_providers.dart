import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_preference_keys.dart';
import '../services/backend_auth_service.dart';

// ============================================================================
// SharedPreferences Provider (overridden in main.dart)
// ============================================================================

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// ============================================================================
// Theme Provider
// ============================================================================

class AppThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final value = prefs.getString(SharedPreferenceKeys.themeMode);
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    final prefs = ref.read(sharedPreferencesProvider);
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(SharedPreferenceKeys.themeMode, value);
    state = mode;
  }

  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

final appThemeNotifierProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);

// ============================================================================
// Backend Auth Provider
// ============================================================================

class BackendAuthState {
  final bool isInitializing;
  final bool isAuthenticated;
  final String? userEmail;
  final String? userId;
  final String? displayName;
  final String? photoUrl;

  const BackendAuthState({
    this.isInitializing = true,
    this.isAuthenticated = false,
    this.userEmail,
    this.userId,
    this.displayName,
    this.photoUrl,
  });

  BackendAuthState copyWith({
    bool? isInitializing,
    bool? isAuthenticated,
    String? userEmail,
    String? userId,
    String? displayName,
    String? photoUrl,
    bool clearUserEmail = false,
    bool clearUserId = false,
    bool clearDisplayName = false,
    bool clearPhotoUrl = false,
  }) {
    return BackendAuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
      userId: clearUserId ? null : (userId ?? this.userId),
      displayName: clearDisplayName ? null : (displayName ?? this.displayName),
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
    );
  }
}

class BackendAuthNotifier extends Notifier<BackendAuthState> {
  late final BackendAuthService _service;

  @override
  BackendAuthState build() {
    _service = BackendAuthService();
    Future.microtask(_initialize);
    return const BackendAuthState();
  }

  BackendAuthService get service => _service;

  Future<void> _initialize() async {
    try {
      await _service.initialize();
      _syncFromService();
    } catch (e) {
      debugPrint('BackendAuthNotifier initialization error: $e');
      state = const BackendAuthState(isInitializing: false);
    }
  }

  void _syncFromService() {
    state = BackendAuthState(
      isInitializing: _service.isInitializing,
      isAuthenticated: _service.isAuthenticated,
      userEmail: _service.userEmail,
      userId: _service.userId,
      displayName: _service.userDisplayName,
      photoUrl: _service.userPhotoUrl,
    );
  }

  Future<void> register(String email, String password) async {
    await _service.register(email, password);
    _syncFromService();
  }

  Future<void> login(String email, String password) async {
    await _service.login(email, password);
    _syncFromService();
  }

  Future<void> logout() async {
    await _service.logout();
    _syncFromService();
  }

  Future<void> authenticateWithGoogle(String firebaseToken) async {
    await _service.authenticateWithGoogle(firebaseToken);
    _syncFromService();
  }

  Future<void> refreshUserInfo() async {
    await _service.refreshUserInfo();
    _syncFromService();
  }

  Future<void> forceLogout() async {
    await _service.forceLogout();
    _syncFromService();
  }
}

final backendAuthProvider =
    NotifierProvider<BackendAuthNotifier, BackendAuthState>(
  BackendAuthNotifier.new,
);
