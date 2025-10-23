/// Base class for all use cases
///
/// Type parameter [Type] is the return type of the use case
/// Type parameter [Params] is the parameter type for the use case
abstract class UseCase<Type, Params> {
  /// Executes the use case
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class NoParamsUseCase<Type> {
  /// Executes the use case
  Future<Type> call();
}

/// Base class for stream use cases
abstract class StreamUseCase<Type, Params> {
  /// Executes the use case
  Stream<Type> call(Params params);
}

/// Placeholder class for use cases that don't need parameters
class NoParams {
  /// Creates a new NoParams instance
  const NoParams();
}
