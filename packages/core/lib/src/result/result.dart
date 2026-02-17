import 'package:core/src/result/failure.dart';

sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  });

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      success(data);
}

class FailureResult<T> extends Result<T> {
  final Failure error;
  const FailureResult(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      failure(error);
}
