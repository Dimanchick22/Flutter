import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  /// Creates a new failure
  const Failure([this.message]);

  /// Optional error message
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Failure that occurs during server communication
class ServerFailure extends Failure {
  /// Creates a new server failure
  const ServerFailure([super.message]);
}

/// Failure that occurs during local storage operations
class CacheFailure extends Failure {
  /// Creates a new cache failure
  const CacheFailure([super.message]);
}

/// Failure that occurs due to network connectivity issues
class NetworkFailure extends Failure {
  /// Creates a new network failure
  const NetworkFailure([super.message]);
}

/// Failure that occurs due to validation errors
class ValidationFailure extends Failure {
  /// Creates a new validation failure
  const ValidationFailure([super.message]);
}

/// Failure that occurs when a resource is not found
class NotFoundFailure extends Failure {
  /// Creates a new not found failure
  const NotFoundFailure([super.message]);
}
