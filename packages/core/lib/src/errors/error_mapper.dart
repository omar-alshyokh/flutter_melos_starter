import 'package:dio/dio.dart';
import '../result/failure.dart';

class ErrorMapper {
  static Failure toFailure(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      final status = error.response?.statusCode;

      // HTTP status mapping
      if (status != null) {
        if (status == 401) {
          return Failure(type: FailureType.unauthorized, message: 'Unauthorized', code: '$status', cause: error);
        }
        if (status == 403) {
          return Failure(type: FailureType.forbidden, message: 'Forbidden', code: '$status', cause: error);
        }
        if (status == 404) {
          return Failure(type: FailureType.notFound, message: 'Not found', code: '$status', cause: error);
        }
        if (status >= 500) {
          return Failure(type: FailureType.server, message: 'Server error ($status)', code: '$status', cause: error);
        }
        return Failure(type: FailureType.unknown, message: 'Request failed ($status)', code: '$status', cause: error);
      }

      // Dio type mapping
      return switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout =>
            Failure(type: FailureType.timeout, message: 'Request timeout', cause: error),
        DioExceptionType.cancel =>
            Failure(type: FailureType.cancelled, message: 'Request cancelled', cause: error),
        DioExceptionType.connectionError =>
            Failure(type: FailureType.network, message: 'Connection error', cause: error),
        DioExceptionType.badCertificate =>
            Failure(type: FailureType.network, message: 'Bad certificate', cause: error),
        DioExceptionType.badResponse =>
            Failure(type: FailureType.unknown, message: 'Bad response', cause: error),
        DioExceptionType.unknown =>
            Failure(type: FailureType.unknown, message: 'Unexpected error', cause: error),
      };
    }

    return Failure(type: FailureType.unknown, message: 'Unexpected error', cause: error);
  }
}
