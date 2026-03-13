import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

typedef UnauthorizedCallback = void Function();

class ApiService {
  static final String _devUrl =
      dotenv.env['API_BASE_URL_DEV'] ?? 'http://localhost:8010';
  static final String _prodUrl =
      dotenv.env['API_BASE_URL_PROD'] ?? 'http://localhost:8010';
  static final String baseUrl = kReleaseMode ? _prodUrl : _devUrl;
  static const String apiBase = '/api';

  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  UnauthorizedCallback? onUnauthorized;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl + apiBase,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.d('REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE[${response.statusCode}] => ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e('ERROR[${error.response?.statusCode}] => ${error.message}');

          final responseData = error.response?.data;
          final errorDetail = responseData is Map ? responseData['error'] : null;

          if (error.response?.statusCode == 401) {
            final isRefreshError = error.requestOptions.path == '/auth/refresh';

            if (!isRefreshError && !_isRefreshing) {
              _isRefreshing = true;

              try {
                final refreshed = await refreshAccessToken();

                if (refreshed) {
                  final opts = error.requestOptions;
                  final newToken = await getToken();
                  opts.headers['Authorization'] = 'Bearer $newToken';

                  try {
                    final response = await _dio.fetch(opts);
                    return handler.resolve(response);
                  } catch (retryError) {
                    return handler.next(error);
                  }
                } else {
                  await deleteTokens();
                  onUnauthorized?.call();
                }
              } finally {
                _isRefreshing = false;
              }
            } else if (isRefreshError) {
              await deleteTokens();
              onUnauthorized?.call();
            }
          }

          if (errorDetail == 'User not found') {
            await deleteTokens();
            onUnauthorized?.call();
          }

          return handler.next(error);
        },
      ),
    );
  }

  // Token Management
  static const String _accessTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  bool _isRefreshing = false;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl + apiBase,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String;

      await saveTokens(newAccessToken, newRefreshToken);
      return true;
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      return false;
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );
      final accessToken = response.data['access_token'] as String;
      final refreshToken = response.data['refresh_token'] as String;
      await saveTokens(accessToken, refreshToken);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final accessToken = response.data['access_token'] as String;
      final refreshToken = response.data['refresh_token'] as String;
      await saveTokens(accessToken, refreshToken);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> authenticateWithFirebase(String firebaseToken) async {
    try {
      final response = await _dio.post(
        '/auth/google',
        data: {'firebase_token': firebaseToken},
      );
      final accessToken = response.data['access_token'] as String;
      final refreshToken = response.data['refresh_token'] as String;
      await saveTokens(accessToken, refreshToken);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      _logger.e('Logout error: $e');
    } finally {
      await deleteTokens();
    }
  }

  // Meme endpoints
  Future<Map<String, dynamic>> generateMeme(String topic) async {
    try {
      final response = await _dio.post(
        '/memes/generate',
        data: {'topic': topic},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getTrendingMemes({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _dio.get(
        '/memes/trending',
        queryParameters: {'pageNumber': page, 'pageSize': pageSize},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getDailyMeme() async {
    try {
      final response = await _dio.get('/memes/daily');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getMemesByTopic(String topic) async {
    try {
      final response = await _dio.get('/memes/topic/$topic');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> saveMeme(String memeId) async {
    try {
      await _dio.post('/memes/save', data: {'meme_id': memeId});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getSavedMemes() async {
    try {
      final response = await _dio.get('/memes/saved');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic HTTP methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
      return 'Error: ${error.response!.statusMessage}';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check your internet connection.';
    }

    return 'An unexpected error occurred: ${error.message}';
  }
}
