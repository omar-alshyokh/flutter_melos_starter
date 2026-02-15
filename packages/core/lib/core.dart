export 'network/dio_factory.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure error;
  const Failure(this.error);
}

class AppFailure {
  final String message;
  final Object? cause;

  const AppFailure(this.message, {this.cause});
}


