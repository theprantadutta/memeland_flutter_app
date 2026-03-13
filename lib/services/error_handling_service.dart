class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred']) : super(message, code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication error']) : super(message, code: 'AUTH_ERROR');
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred']) : super(message, code: 'SERVER_ERROR');
}
