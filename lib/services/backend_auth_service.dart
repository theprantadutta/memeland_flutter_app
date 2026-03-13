import 'package:flutter/foundation.dart';
import 'api_service.dart';

class BackendAuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isInitializing = true;
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userId;
  String? _displayName;
  String? _photoUrl;

  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userDisplayName => _displayName;
  String? get userPhotoUrl => _photoUrl;

  Future<void> initialize() async {
    _isInitializing = true;
    notifyListeners();

    _apiService.onUnauthorized = _handleUnauthorized;

    try {
      final hasToken = await _apiService.hasToken();

      if (hasToken) {
        final refreshed = await _apiService.refreshAccessToken();

        if (refreshed) {
          await refreshUserInfo();
        } else {
          await _apiService.deleteTokens();
          _isAuthenticated = false;
        }
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      _isAuthenticated = false;
      try {
        await _apiService.deleteTokens();
      } catch (_) {}
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  void _handleUnauthorized() {
    forceLogout();
  }

  Future<void> forceLogout() async {
    _isAuthenticated = false;
    _userEmail = null;
    _userId = null;
    _displayName = null;
    _photoUrl = null;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      final response = await _apiService.register(email, password);
      _userId = response['user_id']?.toString();
      _userEmail = email;
      _isAuthenticated = true;
      await refreshUserInfo();
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      _userId = response['user_id']?.toString();
      _userEmail = email;
      _isAuthenticated = true;
      await refreshUserInfo();
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _isAuthenticated = false;
      _userEmail = null;
      _userId = null;
      _displayName = null;
      _photoUrl = null;
      notifyListeners();
    }
  }

  Future<void> authenticateWithGoogle(String firebaseToken) async {
    try {
      final response = await _apiService.authenticateWithFirebase(firebaseToken);
      _userId = response['user_id']?.toString();
      _isAuthenticated = true;
      await refreshUserInfo();
      notifyListeners();
    } catch (e) {
      throw Exception('Google authentication failed: $e');
    }
  }

  Future<void> refreshUserInfo() async {
    try {
      final userInfo = await _apiService.getCurrentUser();
      _userId = userInfo['id']?.toString();
      _userEmail = userInfo['email'];
      _displayName = userInfo['display_name'];
      _photoUrl = userInfo['photo_url'];
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch user info: $e');
    }
  }
}
