/// Base class for all exceptions in the application
class AppException implements Exception {
  /// Creates a new app exception
  const AppException([this.message]);

  /// Optional error message
  final String? message;

  @override
  String toString() => message ?? 'AppException';
}

/// Exception thrown when server communication fails
class ServerException extends AppException {
  /// Creates a new server exception
  const ServerException([super.message]);
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  /// Creates a new cache exception
  const CacheException([super.message]);
}

/// Exception thrown when network is unavailable
class NetworkException extends AppException {
  /// Creates a new network exception
  const NetworkException([super.message]);
}
