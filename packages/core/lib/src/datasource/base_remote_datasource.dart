import 'package:dio/dio.dart';
import '../network/network_call.dart';
import '../result/result.dart';
import '../result/failure.dart';
import '../errors/error_mapper.dart';
import '../network/json_types.dart';

abstract class BaseRemoteDataSource {
  final Dio dio;
  BaseRemoteDataSource(this.dio);

  /// GET returning a DTO (object)
  Future<Result<T>> getObject<T>({
    required String path,
    Map<String, dynamic>? query,
    Options? options,
    required T Function(JsonMap json) fromJson,
  }) {
    return NetworkCall.guard(() async {
      final res = await dio.get(path, queryParameters: query, options: options);
      final data = res.data;

      if (data is! Map<String, dynamic>) {
        throw Failure(
          type: FailureType.parsing,
          message: 'Invalid response format (expected object)',
          cause: data,
        );
      }

      return fromJson(data);
    });
  }

  /// GET returning a list of DTOs
  Future<Result<List<T>>> getList<T>({
    required String path,
    Map<String, dynamic>? query,
    Options? options,
    required T Function(JsonMap json) fromJson,
  }) {
    return NetworkCall.guard(() async {
      final res = await dio.get(path, queryParameters: query, options: options);
      final data = res.data;

      if (data is! List) {
        throw Failure(
          type: FailureType.parsing,
          message: 'Invalid response format (expected list)',
          cause: data,
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList(growable: false);
    });
  }

  /// POST returning a DTO (object)
  Future<Result<T>> postObject<T>({
    required String path,
    Object? body,
    Map<String, dynamic>? query,
    Options? options,
    required T Function(JsonMap json) fromJson,
  }) {
    return NetworkCall.guard(() async {
      final res = await dio.post(path, data: body, queryParameters: query, options: options);
      final data = res.data;

      if (data is! Map<String, dynamic>) {
        throw Failure(
          type: FailureType.parsing,
          message: 'Invalid response format (expected object)',
          cause: data,
        );
      }

      return fromJson(data);
    });
  }

  /// POST returning raw JSON (sometimes APIs return primitive/list)
  Future<Result<dynamic>> postRaw({
    required String path,
    Object? body,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return NetworkCall.guard(() async {
      final res = await dio.post(path, data: body, queryParameters: query, options: options);
      return res.data;
    });
  }
}
